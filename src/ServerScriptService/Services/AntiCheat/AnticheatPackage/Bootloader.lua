-- Madonox
-- 2023

-- Main entry point, starts whole system and maintains table protection.

local Bootloader = {
	ModificationEnvironment = {
		Started = false;
		Services = {};
		API = nil;
	};
}

-- See post https://devforum.roblox.com/t/be-careful-when-using-assert-and-why/1289175, assert has issues.
local function safeAssert(value,response)
	if value == false then
		warn("Bootloader error: "..response)
		error("") -- Message is a warning, use error to stop execution.
	end
end

function Bootloader.Start(configuration,pluginDirectory)
	local gameCode = game.JobId.."-BitAntiCheat"
	safeAssert(shared[gameCode] ~= true,"You can only have one instance of the BitAntiCheat in your game!")
	safeAssert(Bootloader.ModificationEnvironment.Started ~= true,"You can only start the bootloader once!")
	safeAssert(#Bootloader.ModificationEnvironment.Services == 0,"WARNING: service table modification detected!  This may result in security vulnurabilities!")
	
	shared[gameCode] = true
	Bootloader.ModificationEnvironment.Started = true
	
	-- Load anticheat.
	local immuneUsers = configuration.WhitelistedUsers or {}
	local detectedModules = {}
	for _,service in script.Parent:WaitForChild("Services"):GetDescendants() do
		if service:IsA("ModuleScript") then
			local module = require(service)
			
			if tostring(module) == "AnticheatService" then
				detectedModules[service.Name] = setmetatable({
					Services = detectedModules;
					Environment = Bootloader.ModificationEnvironment;
					WhitelistedUsers = immuneUsers;
				},{
					__metatable = "Locked.";
					__index = module;
					--__newindex = {};
				})
				if module.Initialize then
					module:Initialize()
				end
			end
		end
	end
	table.freeze(detectedModules)
	Bootloader.ModificationEnvironment.Services = detectedModules
	--table.freeze(Bootloader.ModificationEnvironment.Services)
	
	for name,service in Bootloader.ModificationEnvironment.Services do
		if service.Start then
			service:Start(configuration.Services[name])
		end
	end
	
	Bootloader.ModificationEnvironment.API = require(script.Parent:WaitForChild("API"):WaitForChild("Entry"))
	Bootloader.ModificationEnvironment.API.Environment.Services = Bootloader.ModificationEnvironment.Services
	
	-- Freezes the environment once loading is done.
	table.freeze(Bootloader.ModificationEnvironment)
	
	-- Used to log about configuration changes.
	if configuration.Configuration_Version ~= 1.1 then
		warn("WARNING: your BitAntiCheat configuration/loader is out-of-date!  Please update it ASAP.")
	end
	
	-- Start plugins.
	for _,object in pluginDirectory:GetDescendants() do
		if object:IsA("ModuleScript") then
			local req = require(object)
			if typeof(req) == "function" then
				req(detectedModules)
				continue
			end
			warn(string.format("WARNING: Cannot start BitAntiCheat plugin %s!  Plugin does not return a function.",object.Name))
		end
	end
end

function Bootloader.StreamAPI()
	assert(Bootloader.ModificationEnvironment.Started == true,"You can only call the API once the bootloader has started!")
	return Bootloader.ModificationEnvironment.API
end

return table.freeze(Bootloader)