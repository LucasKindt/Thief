-- Path.lua

local Path = {}
Path.__index = Path

local PathfindingService = game:GetService("PathfindingService")
local TweenService = game:GetService("TweenService")

function Path.new(npc)
	if not npc.humanoid then
		return false
	end
	
	local self = setmetatable({}, Path)
	
	self.npc = npc
	self.path = nil
	self.destination = nil
	self.MoveAttempts = 0
	
	return self
end

function Path:CreatePath(destination)
	local path = PathfindingService:CreatePath({
		AgentRadius = 0.75,
		AgentHeight = 5.0,
		AgentCanJump = false
	})
	
	path:ComputeAsync(self.npc.rootPart.Position, destination)
	
	self.path = path
	self.destination = destination
	return true
end

function Path:MoveTo()
	local waypoints = self.path:GetWaypoints()
	local nextWaypointIndex = 2
	
	local npc = self.npc
	local path = self.path

	path.Blocked:Connect(function(blockedWaypointIdx)
		if blockedWaypointIdx > nextWaypointIndex then
			if self.MoveAttempts >= 3 then
				return false
			end
			
			self:CreatePath(self.destination)
			if self.path.Status == Enum.PathStatus.Success then
				self:MoveTo()
			end
		end
	end)

	if path.Status == Enum.PathStatus.Success and #waypoints > 0 then
		local humanoid = npc.humanoid
		if humanoid then
			humanoid:MoveTo(waypoints[nextWaypointIndex].Position)
			
			-- Play walking animation
			local walkAnimation = self.npc.model:FindFirstChild("WalkAnim", true)
			if walkAnimation then
				local animation = humanoid:LoadAnimation(walkAnimation)
				animation:Play()
			else
				warn("Walk animation not found for NPC: " .. npc.model.Name)
			end
			
			humanoid.MoveToFinished:Connect(function(reached)
				if reached and nextWaypointIndex < #waypoints then
					nextWaypointIndex += 1
					humanoid:MoveTo(waypoints[nextWaypointIndex].Position)
				end
			end)
			
			while true do
				if nextWaypointIndex >= #waypoints then
					break
				end
				task.wait(0.3) -- Wait 0.5 seconds to prevent from lagging
				local cast = workspace:Raycast(npc.rootPart.Position, npc.rootPart.CFrame.LookVector * 5, RaycastParams.new()) -- Get what Player is looking at
				if cast and cast.Instance then -- If Player is looking at something and something is an object then
					if cast.Instance.Name == 'Base' or cast.Instance.Name == 'Hinge' and cast.Instance.Parent:FindFirstChild('PathfindingModifier', true) then
						npc:HandleDoor(cast.Instance.Parent)
					end
				end
			end

			npc:StopAllAnimations()
			
			return true
		end
	end
	return false
end

function Path:Destroy()
	self = nil
end

return Path