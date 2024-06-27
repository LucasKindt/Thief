local TweenService = game:GetService("TweenService")

local hinge = script.Parent.Hinge
local prompt = script.Parent.Base.ProximityPrompt

local goalOpen = {}
goalOpen.CFrame = hinge.CFrame * CFrame.Angles(0, math.rad(90), 0)

local goalClose = {}
goalClose.CFrame = hinge.CFrame * CFrame.Angles(0, 0, 0)

local event = game.ReplicatedStorage.Events.Lockpick

local LockpickingGUI = game.ReplicatedStorage.UI.LockPickGui

local tweenInfo = TweenInfo.new(1)
local tweenOpen = TweenService:Create(hinge, tweenInfo, goalOpen)
local tweenClose = TweenService:Create(hinge, tweenInfo, goalClose)

event.OnServerEvent:Connect(function(player, doorname)
	if script.Parent.Name == doorname then
		prompt.ActionText = "Open"
	end
end)

prompt.Triggered:Connect(function(player)
	if prompt.ActionText == "Close" then
		tweenClose:Play()
		prompt.ActionText = "Open"
	elseif prompt.ActionText == "Open" then
		tweenOpen:Play()
		prompt.ActionText = "Close"
	elseif prompt.ActionText == "Unlock" then
		local players = game.Players:FindFirstChild(player.Name) 
		local lockpick = players.Character:FindFirstChild("LockPick")

		if lockpick then--If it finds lockpick inside character then
			lockpick:Destroy()--Removes the lockpick

			local gui = LockpickingGUI:Clone()
			local randomid = math.random(10000, 99999)
			gui.Parent = player.PlayerGui
			gui.CurrentID.Value = randomid
			script.Parent.Name = randomid
		end
	end
end)