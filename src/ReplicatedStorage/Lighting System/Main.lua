local LightingSystem = script.Parent
local LightingModules = LightingSystem:WaitForChild("Lighting Presets")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

local Functions = require(LightingSystem.Functions)

local Sunrise = false
local Day = false
local MorningGoldenHour = false
local AfternoonGoldenHour = false
local Night = false
local Sunset = false
local Twilight = false

local SunRiseModule = require(LightingModules.Sunrise)
local DayModule = require(LightingModules.Day)
local MorningGoldenHourModule = require(LightingModules.MorningGoldenHour)
local AfternoonGoldenHourModule = require(LightingModules.AfternoonGoldenHour)
local NightModule = require(LightingModules.Night)
local SunsetModule = require(LightingModules.Sunset)
local TwilightModule = require(LightingModules.Twilight)

local DefaultClocktime = Lighting.ClockTime

function ChangeStuff(Scenary_)
	Functions:setLightingSettings(Scenary_)
end

Lighting.ClockTime = DefaultClocktime + 1
Lighting.ClockTime = DefaultClocktime

Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
	if (Sunrise == false) and (Lighting.ClockTime >= 06 and Lighting.ClockTime <= 08) then
		Sunrise = true
		Day = false
		MorningGoldenHour = false
		Night = false
		Sunset = false
		Twilight = false
		AfternoonGoldenHour = false
		ChangeStuff(SunRiseModule)
	elseif (Day == false) and (Lighting.ClockTime > 08 and Lighting.ClockTime <= 17) then
		Day = true
		Sunrise = false
		MorningGoldenHour = false
		Night = false
		Sunset = false
		Twilight = false
		AfternoonGoldenHour = false
		ChangeStuff(DayModule)
	elseif (AfternoonGoldenHour == false) and (Lighting.ClockTime > 17 and Lighting.ClockTime <= 18.5) then
		AfternoonGoldenHour = true
		Day = false
		Sunrise = false
		MorningGoldenHour = false
		Night = false
		Sunset = false
		Twilight = false
		ChangeStuff(AfternoonGoldenHourModule)
	elseif (Sunset == false) and (Lighting.ClockTime > 18.5 and Lighting.ClockTime <= 20) then
		Sunset = true
		AfternoonGoldenHour = false
		Day = false
		Sunrise = false
		MorningGoldenHour = false
		Night = false
		Twilight = false
		ChangeStuff(SunsetModule)
	elseif (Twilight == false) and (Lighting.ClockTime > 20 and Lighting.ClockTime <= 23) then
		Twilight = true
		Sunset = false
		AfternoonGoldenHour = false
		Day = false
		Sunrise = false
		MorningGoldenHour = false
		Night = false
		Sunset = false
		ChangeStuff(TwilightModule)
	elseif (Night == false) and (Lighting.ClockTime > 23 and Lighting.ClockTime <= 06) then
		Night = true
		Twilight = false
		Sunset = false
		AfternoonGoldenHour = false
		Day = false
		Sunrise = false
		MorningGoldenHour = false
		Sunset = false
		ChangeStuff(NightModule)
	end
end)

return true