-- Madonox
-- 2023

local RunService = game:GetService("RunService")

local ThreadEventService = setmetatable({},{
	__tostring = function()
		return "AnticheatService"
	end
})

function ThreadEventService:MakeEventThread()
	local memory = {}
	
	local thread = RunService.Heartbeat:Connect(function(deltaTime)
		for _,connection in memory do
			local newElapsed = connection.Elapsed + deltaTime
			local interval = connection.Interval
			if newElapsed > interval then
				newElapsed = newElapsed - deltaTime - interval
				connection.Callback()
			end
			
			connection.Elapsed = newElapsed
		end
	end)
	
	local function cancel()
		thread:Disconnect()
		thread = nil
		for _,connection in memory do
			table.clear(connection)
		end
		table.clear(memory)
	end
	local function createRuntime(interval,callback)
		local newPackage = {
			Callback = callback;
			Interval = interval;
			Elapsed = 0;
		}
		
		table.insert(memory,newPackage)
	end
	
	return {
		Thread = thread;
		Cancel = cancel;
		Bind = createRuntime;
	}
end

return ThreadEventService