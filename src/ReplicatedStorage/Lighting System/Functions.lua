local module = {}

local Lighting = game:GetService("Lighting")
local Clouds = workspace:FindFirstChild("Terrain").Clouds
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local tweenInfo = TweenInfo.new(1)

function module:tweenProperty(inst: Instance, propertyName: string, propertyValue: any)
	local tween = TweenService:Create(inst, tweenInfo, {[propertyName] = propertyValue})
	tween:Play()
	Debris:AddItem(tween, tweenInfo.Time)
end

function module:setLightingSettings(config)
	for objectName, objectTable in pairs(config) do
		for propertyName, property in pairs(objectTable) do
			local instance
			if objectName == "Lighting" then
				instance = Lighting
			elseif objectName == "Clouds" then
				instance = Clouds
			elseif objectName ~= nil and propertyName ~= nil then
				instance = Lighting:FindFirstChild(objectName)
			end
			if instance then
				module:tweenProperty(instance, propertyName, property)
			end
		end
	end
end

return module
