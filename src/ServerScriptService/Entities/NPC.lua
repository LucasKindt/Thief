-- NPC.lua
local NPC = {}
NPC.__index = NPC

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PathEntity = require(ServerScriptService:WaitForChild("Entities"):WaitForChild("Path"))
local BasicFunctions = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("BasicFunctions"))

function NPC.new(model, data)
	local self = setmetatable({}, NPC)
	self.model = model
	self.data = data
	self.path = PathEntity.new(self)
	self.humanoid = model:FindFirstChildOfClass("Humanoid")
	self.rootPart = model:FindFirstChild("HumanoidRootPart")
	return self
end

function NPC:FollowRoutine()
	spawn(function()
		while true do
			local currentTime = game.Lighting.TimeOfDay
			local closestTime, smallestDifference = nil, math.huge
			local currentSeconds = self:TimeStringToSeconds(currentTime)
			local firstLaunch = self.data.firstLaunch

			if firstLaunch then
				for i, routine in pairs(self.data.routines) do
					local difference = math.abs(self:TimeStringToSeconds(i) - currentSeconds)
					if difference < smallestDifference then
						smallestDifference = difference
						closestTime = i
					end
				end
			end

			for i, routine in pairs(self.data.routines) do
				local routineSeconds = self:TimeStringToSeconds(i)
				local difference = math.abs(currentSeconds - routineSeconds)
				if difference <= 60 or (firstLaunch and closestTime == i) then	
					firstLaunch = false

					local path = PathEntity.new(self)
					
					path:CreatePath(routine.waypoint)
					
					if path:MoveTo() then
						self:ExecuteAction(routine.action, routine.actionObject)
						path:Destroy()
					else
						warn("Pathfinding failed for character: " .. self.model.Name .. " to " .. tostring(routine.waypoint))
						path:Destroy()
					end
				end
			end
			task.wait(1) -- Check every second
		end
	end)
end

function NPC:DetectPlayers()
	spawn(function()
		while true do
			for _, player in pairs(Players:GetPlayers()) do
				if self:IsPlayerInView(player) then
					self:CallPolice()
				end
			end
			wait(0.5)
		end
	end)
end

function NPC:DetectPlayersBySound(distance)
	spawn(function()
		while true do
			local rootPart = self.rootPart

			if not rootPart then 
				return 
			end

			for _, player in pairs(Players:GetPlayers()) do
				local character = player.Character
				if character then
					local humanoid = character:FindFirstChildOfClass("Humanoid")
					local isCrouching = game.ReplicatedStorage.Events.IsCrouched:InvokeClient(player)
					if humanoid and not isCrouching then
						local distanceBetween = (rootPart.Position - character.PrimaryPart.Position).magnitude
						if distanceBetween <= BasicFunctions.CalculateStudsFromMeters(distance) then
							self:CallPolice()
						end
					end
				end
			end
			
			wait(0.35)
		end
	end)
end

function NPC:IsPlayerInView(player)
	local playerRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not self.rootPart or not playerRootPart then return false end

	local npcPosition = self.rootPart.Position
	local playerPosition = playerRootPart.Position
	local directionToPlayer = (playerPosition - npcPosition).unit

	-- Raycasting to check if there's a clear line of sight
	local rayOrigin = npcPosition + Vector3.new(0, 5, 0)  -- Start from NPC's head level
	local rayDirection = playerPosition - rayOrigin  -- Raycast towards the player's position
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = {self.model, player.Character}  -- Ignore the NPC and player models
	raycastParams.IgnoreWater = true

	local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

	-- Check if the ray hits the player or is clear
	if raycastResult then
		-- If the ray hits something before reaching the player, it's an obstacle
		if raycastResult.Instance.Parent ~= player.Character then
			return false
		end
	end

-- Check if player is within the NPC's field of view
	local npcForwardVector = self.rootPart.CFrame.LookVector
	local directionToPlayer = (playerRootPart.Position - npcPosition).unit
	local dotProduct = npcForwardVector:Dot(directionToPlayer)
	local fovThreshold = math.cos(math.rad(90))  -- 90 degrees FOV

	if dotProduct >= fovThreshold then
		return true
	end

	return false
end


function NPC:ExecuteAction(action, actionObject)
	local humanoid_state = self.humanoid:GetState()

	if action == "idle" then
		local idleAnimation = self.model:FindFirstChild("IdleAnim2", true)
		if idleAnimation then
			local animation = self.humanoid:LoadAnimation(idleAnimation)
			animation:Play()
		else
			error("Animation not found")
		end
	elseif action == "sit" and actionObject then
		actionObject:Sit(self.humanoid)
		if humanoid_state == Enum.HumanoidStateType.Running then
			local sitAnimation = self.model:FindFirstChild("SitAnim", true)
			if sitAnimation then
				local animation = self.humanoid:LoadAnimation(sitAnimation)
				animation:Play()
			else
				error("Animation not found")
			end
		end
	end
end

function NPC:HandleDoor(door)
	local hinge = door.Hinge
	local goalOpen = {CFrame = hinge.CFrame * CFrame.Angles(0, math.rad(90), 0)}
	local goalClose = {CFrame = hinge.CFrame * CFrame.Angles(0, 0, 0)}
	local tweenInfo = TweenInfo.new(1)
	local tweenOpen = TweenService:Create(hinge, tweenInfo, goalOpen)
	local tweenClose = TweenService:Create(hinge, tweenInfo, goalClose)
	tweenOpen:Play()
	wait(3)
	tweenClose:Play()
end

function NPC:StopAllAnimations()
	local humanoid = self.humanoid
	if humanoid then
		local RunningAnimations = humanoid:GetPlayingAnimationTracks()
		if #humanoid:GetPlayingAnimationTracks() ~= 0 then
			for i, animation in pairs(RunningAnimations) do
				if animation.IsPlaying == true then
					animation:Stop()
					if animation.Name == 'SitAnim' then
						self.rootPart.CFrame = self.rootPart.CFrame * CFrame.new(0,0,-5)
					end
				end	
			end

			if #humanoid:GetPlayingAnimationTracks() == 0 then
				return true
			end
		else
			return true
		end
	end
	return false
end


function NPC:TimeStringToSeconds(timeString)
	local hours, minutes = string.match(timeString, "(%d+):(%d+)")
	return tonumber(hours) * 3600 + tonumber(minutes) * 60
end

function NPC:CallPolice()
	print('CALLING POLICE!')
end

return NPC