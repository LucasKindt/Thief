-- Entities
local NPC = require(game.ServerScriptService.Entities.NPC)

-- Serviceslocal DataStore2 = require(game:GetService("ServerScriptService").Services.DataService)

local Players = game:GetService("Players")
local DataStore2 = require(game:GetService("ServerScriptService").Services.DataService)

-- Modules
local PlayerDataModule = require(game.ServerScriptService:WaitForChild("Modules"):WaitForChild("PlayerDataModule"))
local MapModule = require(game:GetService("ServerScriptService").Modules.MapModule)

-- Lists
local PathsList = require(game.ServerScriptService.Lists.PathsList)

-- Workspace
local Properties = workspace.Properties

local function InitializeAI()
	for _, house in pairs(Properties:GetChildren()) do
		if PathsList[tostring(house)] then
			for npcName, npcData in pairs(PathsList[tostring(house)]) do
				local character = house.Tenants[npcName]
				local npc = NPC.new(character, npcData)

				npc:FollowRoutine()

				npc:DetectPlayers()

				npc:DetectPlayersBySound(npcData.hearingDistance)
			end
		end
	end
end


-- Init player data on connection
Players.PlayerAdded:Connect(function(player)
	PlayerDataModule.InitPlayerData(player)
	task.wait(0.1)
	MapModule.initMap(player)
	task.wait(0.1)
	InitializeAI()
end)