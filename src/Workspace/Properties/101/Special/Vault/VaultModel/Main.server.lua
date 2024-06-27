--Made By Timme, Please Read the Comments Carefully.
local ProximityPrompt = script.Parent.Door.ProximityPrompt -- Where it searches for the Prox

local ValuesFolder = script.Parent.Values

local breaksfx = script.Parent.Door.Break

local animationcontroller = script.Parent:WaitForChild("AnimationController")--We use animationController because it doesn't contain a humanoid

--||Animations For the Value||--
local openanimation = script.Parent:WaitForChild("Open")
local openanimationTrack = animationcontroller:LoadAnimation(openanimation)

local holdanimation = script.Parent:WaitForChild("Hold")
local holdanimationTrack = animationcontroller:LoadAnimation(holdanimation)

local closeanimation = script.Parent:WaitForChild("Close")
local closeanimationTrack = animationcontroller:LoadAnimation(closeanimation)

local event = game.ReplicatedStorage.Events.Lockpick

local LockpickingGUI = game.ReplicatedStorage.UI.LockPickGui

local CooldownTimeForReset = 30--Change 


ProximityPrompt.Triggered:Connect(function(player)--Player Triggered the prompt(you can change this to somthing else example:clickdetectors)
	local lockpick = player.Character:FindFirstChild("LockPick")--Checks if player is holding the lockpick tool (should be a child of the player model)
	if lockpick then--If it finds lockpick inside character then
	lockpick:Destroy()--Removes the lockpick
		local gui = LockpickingGUI:Clone()
		local randomid = math.random(10000, 99999)
		gui.Parent = player.PlayerGui
		gui.CurrentID.Value = randomid
		script.Parent.Name = randomid
		
		event.OnServerEvent:Connect(function(player, uniqueID)
			if tonumber(uniqueID) == tonumber(randomid) then
				print(2)
				ProximityPrompt.Enabled = false
				breaksfx:Play()
				openanimationTrack:Play()--Plays the vault opening animation (not looped)
				holdanimationTrack:Play()--Players the vault idle animation (looped)
				task.wait(CooldownTimeForReset)
				holdanimationTrack:Stop()--Stops the vault idle animation
				closeanimationTrack:Play()--Players the vault close animations (not looped)
				ProximityPrompt.Enabled = true
			end
		end)
	end
end) 