local Roact = require(game:GetService("ReplicatedStorage").Roact)
local Settings = require(script.Parent.Parent.Parent.Parent:WaitForChild("Settings"))

local ToolTip = require(script.Parent.ToolTip)

local plr = game:GetService("Players").LocalPlayer
local cam = game.Workspace.CurrentCamera

local player = Roact.Component:extend("Player")

function player:init()
	self:setState({
		Rotation = 0;
	})
end

function player:render()
	local Rot = self.state.Rotation
	
	return Roact.createElement("ImageLabel", {
		Image = "rbxassetid://"..Settings["Gui"]["playerIcon"];
		Size = Settings["Gui"]["playerSize"];
		
		BackgroundTransparency = 1;
		Position = UDim2.new(.5,0,.5,0);
		AnchorPoint = Vector2.new(.5,.5);
		ZIndex = 10;
		
		Rotation = Rot;
	})
end

local function getAngleAboutYAxis(R)
	local px, py, pz,
	xx, yx, zx,
	xy, yy, zy,
	xz, yz, zz = R:components()

	return math.atan2(zx - xz, xx + zz)
end

function player:didMount()
	self.renderLoop = game:GetService("RunService").RenderStepped:connect(function()
		local char = plr.Character or plr.CharacterAdded:wait()

		local rootpart = char:FindFirstChild("HumanoidRootPart")
		if rootpart then
			--local direction = cam.CFrame.lookVector
			--local heading = math.atan2(direction.x,direction.z)
			--heading = math.deg(heading)
			
			local heading = math.deg(getAngleAboutYAxis(cam.CFrame))
			local orientation = math.deg(getAngleAboutYAxis(rootpart.CFrame))
			
			if Settings["Technical"]["rotation"] == true then
				self:setState(function(state)
					return{
						Rotation = (heading - orientation);
					}
				end)
			else
				print(orientation)
				self:setState(function(state)
					return{
						Rotation = -orientation;
					}
				end)
			end
		end
	end)
end

function player:willUnmount()
	self.renderLoop:Disconnect()
	
	if self.toolTip then
		Roact.unmount(self.toolTip)
	end
end

return player
