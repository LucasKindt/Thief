-- Madonox
-- 2023

-- Main module used to provide updates instantly.

return function(...)
	local package = script:WaitForChild("AnticheatPackage")
	package.Parent = game:GetService("ServerScriptService")
	
	local bootloader = require(package:WaitForChild("Bootloader"))
	
	bootloader.Start(...)
	
	return bootloader
end