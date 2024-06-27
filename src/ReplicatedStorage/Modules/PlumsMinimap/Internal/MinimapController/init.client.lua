local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

local plr = Players.LocalPlayer

local RunService = game:GetService("RunService")

if not RunService:IsStudio() then
	warn("⭐Plum's Minimap is starting up...⭐")
end

local function getAngleAboutYAxis(R)
	local px, py, pz,
	xx, yx, zx,
	xy, yy, zy,
	xz, yz, zz = R:components()

	return math.atan2(zx - xz, xx + zz)
end

--if script.Parent.Parent.Parent == plr:WaitForChild("PlayerScripts") then
	local Settings = require(script.Parent.Parent:WaitForChild("Settings"))
	
	Settings["Divide"] = 1
	
	if Settings["Map"]["mapId"] then
		if Settings["Map"]["size"].Y > 1024 or Settings["Map"]["size"].X > 1024 then
			--Settings["Divide"] = Settings["Map"]["size"].Y > 1024 and (Settings["Map"]["size"].Y/1024) or Settings["Map"]["size"].X > 1024 and (Settings["Map"]["size"].X/1024)
			Settings["Divide"] = math.max(Settings["Map"]["size"].Y, Settings["Map"]["size"].X) / 1024
		end
	else
		local max = 0
		for _, data in Settings["Map"]["images"] do
			local thisMax = math.max(data.size.X, data.size.Y)
			if thisMax > max then
				max = thisMax
			end
		end
		
		if max > 1024 then
			Settings["Divide"] = max / 1024
		end
	end

	local Roact = require(script.Parent:WaitForChild("Roact"))

	script.Parent:WaitForChild("Roact").Parent = game:GetService("ReplicatedStorage")

	local MinimapCamera = Instance.new("Camera")
	MinimapCamera.Name = "MinimapCamera"
	MinimapCamera.FieldOfView = 70
	MinimapCamera.Parent = workspace	
	
	local cam = game.Workspace.CurrentCamera

	local uiCreationController = require(script:WaitForChild("UiCreationController"))

	local ui = uiCreationController:Init()

	local Handle = Roact.mount(ui,plr:WaitForChild("PlayerGui"))

	local vps = Vector2.new(1920, 1080)
	local mapsize = Settings["Gui"]["mapSize"]
	Settings["Y"] = (mapsize.Y.Offset + (mapsize.Y.Scale*vps.Y) / (math.tan(math.rad(35)) * 2)) + (mapsize.X.Offset + (mapsize.X.Scale*vps.X) / 2)
	
	RunService.RenderStepped:connect(function()
		local char = plr.Character or plr.CharacterAdded:wait()

		local rootpart = char:FindFirstChild("HumanoidRootPart")
		if rootpart then
			
			local ROOTPART_POS = rootpart.CFrame.p
			
			local vps = Vector2.new(1920, 1080)
			local mapsize = Settings["Gui"]["mapSize"]
			local y = (mapsize.Y.Offset + (mapsize.Y.Scale*vps.Y) / (math.tan(math.rad(35)) * 2)) + (((Settings["Gui"]["mapSize"].X.Offset + (Settings["Gui"]["mapSize"].X.Scale*vps.X)) / Settings["Ratio"]) / 2)
			Settings["Y"] = y
		
			local onepixel = Settings["Technical"]["onePixel"]
			local divide = Settings["Divide"]
			
			local P = Vector3.new(ROOTPART_POS.X, (y * onepixel), ROOTPART_POS.Z) / divide
			
			local heading = 0
			if Settings["Technical"]["rotation"] == true then
				heading = math.deg(getAngleAboutYAxis(cam.CFrame))
			end
			MinimapCamera.CFrame = CFrame.new(P) * CFrame.Angles(math.rad(-90), 0, math.rad(heading))
		end
	end)
--else
--	error("The minimap has to be a child of ".. plr:WaitForChild("PlayerScripts"):GetFullName() .."! Current parent: "..script.Parent.Parent.Parent:GetFullName())
--end