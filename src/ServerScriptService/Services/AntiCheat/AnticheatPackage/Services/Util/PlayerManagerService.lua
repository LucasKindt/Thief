-- Madonox
-- 2023

-- Keeps track of and manages player data.

local Players = game:GetService("Players")

local PlayerManagerService = setmetatable({},{__tostring=function()
	return "AnticheatService"
end})

function PlayerManagerService:Start()
	local CharacterService = self.Services.CharacterService
	
	local immunePlayers = self.WhitelistedUsers
	Players.PlayerAdded:Connect(function(player)
		if player:GetAttribute("DataPackageLoaded") ~= true and not table.find(immunePlayers,player.UserId) then
			player:SetAttribute("DataPackageLoaded",true)
			CharacterService:NewCharacter(player,player.Character or player.CharacterAdded:Wait())

			player.CharacterAdded:Connect(function()
				CharacterService:NewCharacter(player,player.Character or player.CharacterAdded:Wait())
			end)
		end
	end)
	
	-- If the game has a long load time, this ensures players will properly load.
	for _,player in Players:GetPlayers() do
		if player:GetAttribute("DataPackageLoaded") ~= true and not table.find(immunePlayers,player.UserId) then
			player:SetAttribute("DataPackageLoaded",true)
			CharacterService:NewCharacter(player,player.Character or player.CharacterAdded:Wait())

			player.CharacterAdded:Connect(function()
				CharacterService:NewCharacter(player,player.Character or player.CharacterAdded:Wait())
			end)
		end
	end
end

return PlayerManagerService