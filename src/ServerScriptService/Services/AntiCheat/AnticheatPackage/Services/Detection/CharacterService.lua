-- Madonox
-- 2023

-- Primary system for listening to character events, and validating certain changes.

local CharacterService = setmetatable({},{__tostring=function()
	return "AnticheatService"
end})
local QueryService;
local FlagService;
local ThreadEventService;

function CharacterService:Start(configurationPackage)
	self.Config = configurationPackage
	QueryService = self.Services.QueryService
	FlagService = self.Services.FlagService
	ThreadEventService = self.Services.ThreadEventService
end

function CharacterService:NewCharacter(owner,model)
	if model:GetAttribute("MoveManagerLoaded") ~= true then
		model:SetAttribute("MoveManagerLoaded",true)
		local thread = ThreadEventService:MakeEventThread()
		
		local humanoid = model:WaitForChild("Humanoid") :: Humanoid
		
		humanoid.Died:Once(function()
			thread.Cancel()
		end)
		humanoid.Destroying:Once(function()
			thread.Cancel()
		end)
		model.Destroying:Once(function()
			thread.Cancel()
		end)
		
		local defaultIgnore = {model}
		
		-- State change checks (defined locally to use local variables):
		if self.Config.DisableStateCheck ~= true then
			local humanoidStateCallbacks = {
				[Enum.HumanoidStateType.Climbing] = function() -- Prevent any fake ladders from being made to climb.
					local activePositions = {}
					local charPos,size = model:GetBoundingBox()
					charPos = charPos.Position -- Originally a CFrame

					for _,part:Instance in QueryService:PartsInRange(charPos,5,defaultIgnore) do
						if part:IsA("TrussPart") then
							return
						elseif part:IsA("BasePart") then
							table.insert(activePositions,part.Position)
						end
					end

					-- Check for custom ladders.
					for _,activePos in activePositions do
						local activeY = activePos.Y
						for _,otherPos in activePositions do
							if otherPos ~= activePos then
								if math.abs(activeY-otherPos.Y) <= 1.5 then
									return
								end
							end
						end
					end

					-- If the thread keeps executing, then the player should now be punished.
					model:PivotTo(CFrame.new(QueryService:RaycastDistance(charPos,Vector3.new(0,-1,0),500,defaultIgnore).Position+Vector3.new(0,size.Y/2,0)))
					model.PrimaryPart.Anchored = true
					task.wait(1)
					model.PrimaryPart.Anchored = false
					
					FlagService:Flag(owner)
				end,
				[Enum.HumanoidStateType.Seated] = function() -- Prevent using sitting to fly / other weird glitches.
					local charPos,size = model:GetBoundingBox()
					charPos = charPos.Position -- Originally a CFrame

					for _,part:Instance in QueryService:PartsInRange(charPos,5,defaultIgnore) do
						if part:IsA("Seat") or part:IsA("VehicleSeat") then
							return
						end
					end

					-- Found exploiting, punish.
					humanoid.Sit = false
					humanoid.Jump = true
					model.PrimaryPart.Anchored = true
					model:PivotTo(CFrame.new(QueryService:RaycastDistance(charPos,Vector3.new(0,-1,0),500,defaultIgnore).Position+Vector3.new(0,size.Y/2,0)))
					task.wait(1)
					model.PrimaryPart.Anchored = false
					
					FlagService:Flag(owner)
				end,
			}

			humanoid.StateChanged:Connect(function(old,new)
				local stateCallback = humanoidStateCallbacks[new]
				if stateCallback then
					stateCallback(old,new)
				end
			end)
		end
		
		local rootPart = model:WaitForChild("HumanoidRootPart") :: BasePart
		
		-- Teleportation / speed hack checks (harsher, most likely disabled):
		if self.Config.DisableTeleportCheck ~= true then
			local averageVelocity = 0
			local maxVelocity = humanoid.WalkSpeed
			local lastPosition = rootPart.Position

			humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
				maxVelocity = math.max(maxVelocity,humanoid.WalkSpeed) -- TODO: implement better practices.
			end)
			
			thread.Bind(.75,function()
				local newPos = rootPart.Position
				averageVelocity = (averageVelocity + (newPos - lastPosition).Magnitude) / 2
				if averageVelocity > maxVelocity then
					model:PivotTo(CFrame.new(lastPosition))
				else
					lastPosition = newPos
				end
			end)
		end
		
		if self.Config.DisableVelocityCheck ~= true then
			local ignoreStates = {
				Enum.HumanoidStateType.Jumping,
				Enum.HumanoidStateType.Ragdoll,
				Enum.HumanoidStateType.PlatformStanding,
				Enum.HumanoidStateType.Physics,
				Enum.HumanoidStateType.Dead,
				Enum.HumanoidStateType.FallingDown,
				Enum.HumanoidStateType.Freefall,
				--Enum.HumanoidStateType.Climbing
			}
			
			thread.Bind(.1,function()
				-- Ignore the check if the humanoid is in a specific state.
				if not table.find(ignoreStates,humanoid:GetState()) then
					local currentVelocity = rootPart.AssemblyLinearVelocity
					-- Use math.max to check if the player's falling.  If they're going up, then start checking.
					if Vector3.new(currentVelocity.X,math.max(0,currentVelocity.Y-humanoid.JumpHeight),currentVelocity.Z).Magnitude >= humanoid.WalkSpeed*2 then
						rootPart.Anchored = true
						rootPart.AssemblyLinearVelocity = Vector3.new()
						task.wait(1)
						rootPart.Anchored = false

						FlagService:Flag(owner)
					end
				end
			end)
		end
		
		if self.Config.DisableRotationCheck ~= true then
			local ignoreStates = {
				Enum.HumanoidStateType.Ragdoll,
				Enum.HumanoidStateType.PlatformStanding,
				Enum.HumanoidStateType.Physics,
				Enum.HumanoidStateType.Dead,
			}
			
			local averageRotation = Vector3.new()
			thread.Bind(.1,function()
				if not table.find(ignoreStates,humanoid:GetState()) then
					averageRotation = (rootPart.AssemblyAngularVelocity + averageRotation) / 2
					if averageRotation.Magnitude >= 50 then
						rootPart.Anchored = true
						rootPart.AssemblyAngularVelocity = Vector3.new()
						task.wait(1)
						rootPart.Anchored = false

						FlagService:Flag(owner)
					end
				end
			end)
		end
		
		if self.Config.DisableJumpCheck ~= true then
			local _,size = model:GetBoundingBox()
			local postFlightStates = {
				Enum.HumanoidStateType.Freefall;
				Enum.HumanoidStateType.Flying;
				Enum.HumanoidStateType.Jumping;
			}
			
			humanoid.StateChanged:Connect(function(old,new)
				if new == Enum.HumanoidStateType.Jumping then
					if table.find(postFlightStates,old) then -- Goes from a flying state to another flying state...  Flying loop.
						rootPart.Anchored = true
						rootPart.AssemblyLinearVelocity = Vector3.new()
						model:PivotTo(CFrame.new(QueryService:RaycastDistance(rootPart.Position,Vector3.new(0,-1,0),1000,defaultIgnore).Position+Vector3.new(0,size.Y/2,0)))
						task.wait(1)
						rootPart.Anchored = false

						FlagService:Flag(owner)
						return
					end
					task.wait(.1) -- Wait so the velocity can actually be applied.
					if rootPart.AssemblyLinearVelocity.Y > humanoid.JumpHeight * 1.25 + humanoid.WalkSpeed then
						rootPart.Anchored = true
						rootPart.AssemblyLinearVelocity = Vector3.new()
						model:PivotTo(CFrame.new(QueryService:RaycastDistance(rootPart.Position,Vector3.new(0,-1,0),1000,defaultIgnore).Position+Vector3.new(0,size.Y/2,0)))
						task.wait(1)
						rootPart.Anchored = false
						-- No flag due to possible false-positives.
					end
				end
			end)
		end
		
		-- Multiple tools at once prevention.
		-- This is NOT flagged because lag can occur here, causing errors.
		if self.Config.DisableToolCheck ~= true then
			model.ChildAdded:Connect(function(child)
				local toolCount = 0
				for _,tool in model:GetChildren() do
					if tool:IsA("Tool") then
						toolCount += 1
						if toolCount > 1 then
							task.wait() -- If we don't yield for one step you get a "something unexpectedly tried to set the parent of x..."
							humanoid:UnequipTools()
							break
						end
					end
				end
			end)
		end
	end
end

return CharacterService