local ProximityPromptService = game:GetService("ProximityPromptService")
local PlayerDataModule = require(game:GetService("ServerScriptService").Modules.PlayerDataModule)

local replicatedStorage = game:GetService("ReplicatedStorage")
local events = replicatedStorage:WaitForChild("Events")
local ProximityTriggered = events:WaitForChild("ProximityTriggered")

ProximityTriggered.OnServerEvent:Connect(function(player, itemObject, action)
	-- Steal action
	if action == 'steal' then
		local hitbox = itemObject.hitbox
		PlayerDataModule.StealItem(player, itemObject, hitbox:GetAttribute('house'), hitbox:GetAttribute('name'), hitbox:GetAttribute('id'))
	end
end)