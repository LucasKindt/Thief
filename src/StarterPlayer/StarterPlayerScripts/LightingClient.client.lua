--[[

MADE BY MAIQ_S

How to setup:
1) Read the READ ME script
2) Place the "LightingScenary" script in ServerScriptService and the LightingClient script in StarterPlayerScripts
3) Place the "Lighting System" folder in ReplicatedStorage
4) Enjoy!

To edit the lighting, simply edit one of the module scripts to your liking.

--]]

local LightingModules = game:GetService("ReplicatedStorage"):WaitForChild("Lighting System")
local ClientSidedValue = LightingModules:WaitForChild("Client Sided")
local DeleteScriptIfServerSided = false

if ClientSidedValue.Value then
	require(LightingModules:WaitForChild("Main"))
else
	if DeleteScriptIfServerSided then
		script:Destroy()
	end
end