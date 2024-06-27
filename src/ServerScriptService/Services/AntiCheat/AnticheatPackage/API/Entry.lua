-- Madonox
-- 2023

-- Server API for the anticheat.  Contains most, if not all of the methods that can be interacted with outside the anticheat environment.

local Entry = {
	Environment = {
		Settings = {};
		Services = {};
	}
}

function Entry.OverrideSettings(settingsPackage)
	Entry.Environment.Settings = settingsPackage
end

function Entry.ServiceCall(serviceName,method,...)
	local env = Entry.Environment
	local serviceRef = env.Services[serviceName]
	local wrapped = {...}
	local success,out = pcall(function()
		return serviceRef[method](serviceRef,table.unpack(wrapped))
	end)
	if not success then
		warn("API ServiceCall error: "..out)
		return
	end
	
	if env.Settings.SupressNotifications ~= true then
		warn("ServiceCall is a high-level method.  Please ensure you know what you're doing when using it.  To hide this message, set the configuration attribute [SupressNotifications] to true.")
	end
	
	return out
end

function Entry.DumpService(serviceName,requestedTable)
	warn(`Creating service dump of service {serviceName} into table {requestedTable}.`)
	return setmetatable(requestedTable,{
		__index = Entry.Environment.Services[serviceName]
	})
end

return table.freeze(setmetatable(Entry,{
	__newindex = {};
	__tostring = function()
		return "API"
	end,
}))