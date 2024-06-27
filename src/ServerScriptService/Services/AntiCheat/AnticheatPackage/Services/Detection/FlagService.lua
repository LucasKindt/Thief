-- Madonox
-- 2023

local Players = game:GetService("Players")

local FlagService = setmetatable({
	Punishments = {
		{
			TotalStrikes = 10;
			Action = "kick";
			Parameters = {"You have been kicked for suspected exploiting!"};
		},
	};
},{__tostring=function()
	return "AnticheatService"
end})

function FlagService:Start(configuration)
	if configuration then
		if configuration.Punishments then
			self.Punishments = configuration.Punishments
		end
	end
	
	self.FlagData = {}
	Players.PlayerRemoving:Connect(function(player)
		if self.FlagData[player] then
			self.FlagData[player] = nil
		end
	end)
end

function FlagService:CheckRegistry(player)
	if self.FlagData[player] == nil then
		self.FlagData[player] = 0
	end
end

function FlagService:HandleAction(player,package)
	if package.Action == "kick" then
		player:Kick(table.unpack(package.Parameters))
	end
end

function FlagService:Flag(player)
	self:CheckRegistry(player)
	self.FlagData[player] += 1
	
	local totalStrikes = self.FlagData[player]
	for _,punishment in self.Punishments do
		if punishment.TotalStrikes <= totalStrikes then
			self:HandleAction(player,punishment)
		end
	end
end

return FlagService