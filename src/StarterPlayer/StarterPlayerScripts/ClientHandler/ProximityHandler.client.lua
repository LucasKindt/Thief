local cam = workspace.CurrentCamera -- Get Player Camera
local length = 15 -- Length For Camera
local cfg = RaycastParams.new() -- Get RaycastParams

local print_what_player_is_looking_at = false -- If true, It prints the part name what player is looking at

local lastCast = nil

local player = game.Players.LocalPlayer

local replicatedStorage = game:GetService("ReplicatedStorage")
local events = replicatedStorage:WaitForChild("Events")
local ProximityTriggered = events:WaitForChild("ProximityTriggered")

while true do -- Repeat Forever(loop)
	task.wait(0.3) -- Wait 0.5 seconds to prevent from lagging
	local cast = workspace:Raycast(cam.CFrame.Position, cam.CFrame.LookVector * length, cfg) -- Get what Player is looking at
	if cast and cast.Instance then -- If Player is looking at something and something is an object then
		if print_what_player_is_looking_at == true then -- If player set setting to true(line 7) 
			print(cast.Instance) -- print obejct name 
		end
		if cast.Instance.Name == 'hitbox' and cast.Instance.Attachment then
			if not cast.Instance.Attachment:FindFirstChildOfClass('ProximityPrompt') then
				--local selectionBox = Instance.new('Highlight')
				local ProximityPrompt = Instance.new('ProximityPrompt', cast.Instance.Attachment)
				--selectionBox.Parent = cast.Instance.Parent
				ProximityPrompt:setAttribute('action', 'steal')
				ProximityPrompt.RequiresLineOfSight = false
				ProximityPrompt.MaxActivationDistance = 15
				ProximityPrompt.ClickablePrompt= false
				ProximityPrompt.HoldDuration = 0.7
				
				ProximityPrompt.Triggered:Connect(function()
					ProximityTriggered:FireServer(cast.Instance.Parent, 'steal')
				end)
				lastCast = cast
			end
		else
			if lastCast then
				if lastCast.Instance then
					if lastCast.Instance:FindFirstChild("Attachment") then
						--local selectionBox = lastCast.Instance.Parent:FindFirstChildOfClass('Highlight')
						local ProximityPrompt = lastCast.Instance.Attachment:FindFirstChildOfClass('ProximityPrompt')
						if ProximityPrompt then
							ProximityPrompt:Destroy()
							lastCast = nil
						end
					end
				end
			end
		end
	end
end
