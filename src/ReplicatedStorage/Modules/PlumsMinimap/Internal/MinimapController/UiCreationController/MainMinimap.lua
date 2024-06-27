local Roact = require(game:GetService("ReplicatedStorage").Roact)
local Settings = require(script.Parent.Parent.Parent.Parent:WaitForChild("Settings"))

local RunService = game:GetService("RunService")

local PlayerComponent = require(script.Parent.Player)
local BlipContainerComponent = require(script.Parent.BlipContainer)

local events = script.Parent.Parent.Parent.Events

local mainMinimap = Roact.Component:extend("MainMinimap")

function mainMinimap:init()
	
end

function mainMinimap:render()
	
	
	local vps = Vector2.new(1920,1080)
	local mapsize = Settings["Gui"]["mapSize"]
	local y = (mapsize.Y.Offset + (mapsize.Y.Scale*vps.Y) / (math.tan(math.rad(35)) * 2)) + (mapsize.X.Offset + (mapsize.X.Scale*vps.X) / 2)
	Settings["Y"] = y
	
	if not Settings["Gui"]["Ratio"] then
		Settings["Ratio"] = (mapsize.X.Offset + (mapsize.X.Scale*vps.X)) / (mapsize.Y.Offset + (mapsize.Y.Scale*vps.Y))
	else
		Settings["Ratio"] = Settings["Gui"]["Ratio"]
	end
	
	local parts = {
		Roact.createElement("UICorner", {
			CornerRadius = Settings["Gui"]["mapCornerRoundness"];
		});
	}
	
	--Create all parts
	
	if Settings["Map"]["mapId"] then
		--Insert the map like normal
		if RunService:IsStudio() then
			warn("This minimap uses the legacy map method. Consider switching to the new method!")
		end
		
		table.insert(parts, Roact.createElement("Part", { --The is the map that will be displayed :D
			Size = Vector3.new(Settings["Map"]["size"].X / Settings["Divide"], 0, Settings["Map"]["size"].Y / Settings["Divide"]);
			Position = Settings["Map"]["mapCenter"] and Vector3.new(Settings["Map"]["mapCenter"].X, 0, Settings["Map"]["mapCenter"].Z) / Settings["Divide"] or Vector3.new(0,0,0);
			Orientation = Vector3.new(0, Settings["Technical"]["mapRotation"], 0);
			Transparency = 1
		}, {
			Roact.createElement("Decal", { --Put the textureid here :DDDDDDD
				Texture = "rbxassetid://"..Settings["Map"]["mapId"];
				Face = "Top";
			})
		}))
	else
		--Add all images to parts table
		for _, data in Settings["Map"]["images"] do
			local mapPosition = if data.center then data.center else Vector3.new(0,0,0)
			
			table.insert(parts, Roact.createElement("Part", { --The is the map that will be displayed :D
				--Size = Vector3.new(Settings["Map"]["size"].X / Settings["Divide"], 0, Settings["Map"]["size"].Y / Settings["Divide"]);
				--Position = Settings["Map"]["mapCenter"] and Vector3.new(Settings["Map"]["mapCenter"].X, 0, Settings["Map"]["mapCenter"].Z) / Settings["Divide"] or Vector3.new(0,0,0);
				Size = Vector3.new(data.size.X / Settings["Divide"], 0, data.size.Y / Settings["Divide"]);
				Position =  Vector3.new(mapPosition.X, 0, mapPosition.Z) / Settings["Divide"];
				Orientation = Vector3.new(0, Settings["Technical"]["mapRotation"], 0);
				Transparency = 1
			}, {
				Roact.createElement("Decal", { --Put the textureid here :DDDDDDD
					Texture = "rbxassetid://"..data.mapId;
					Face = "Top";
				})
			}))
		end
	end
	
	return Roact.createElement("ScreenGui", {
		Name = "Minimap";
		ResetOnSpawn = false;
		Enabled = Settings["Technical"]["Visible"];
		ZIndexBehavior = Enum.ZIndexBehavior.Global;
	}, {
		Background = Roact.createElement("Frame", { --This is the border.
			Name = "MinimapBorder";

			Size = mapsize + UDim2.new(0, Settings["Gui"]["borderSize"]*2, 0, Settings["Gui"]["borderSize"]*2);
			AnchorPoint = Settings["Gui"]["anchorPoint"];
			Position = Settings["Gui"]["mapPosition"];
			BackgroundColor3 = Settings["Gui"]["borderColor"];
			BackgroundTransparency = Settings["Gui"]["borderTransparency"];
			BorderSizePixel = 0;
		},{
			Roact.createElement("UIAspectRatioConstraint", {
				DominantAxis = Enum.DominantAxis.Width;
				AspectType = Enum.AspectType.FitWithinMaxSize;
				AspectRatio = Settings["Ratio"];
			});
			Roact.createElement(PlayerComponent);
			Roact.createElement("UICorner", {
				CornerRadius = Settings["Gui"]["borderCornerRoundness"]
			});

			Map = Roact.createElement("ViewportFrame", { --This is the map gui.
				Name = "Map";

				Size = UDim2.new(1, -Settings["Gui"]["borderSize"]*2, 1, -Settings["Gui"]["borderSize"]*2);
				AnchorPoint = Vector2.new(.5,.5);
				Position = UDim2.new(.5,0,.5,0);
				BackgroundColor3 = Settings["Gui"]["mapColor"];
				BackgroundTransparency = Settings["Gui"]["mapTransparency"];
				BorderSizePixel = 0;
				CurrentCamera = game.Workspace.MinimapCamera;
			}, Roact.createFragment(parts));

			BlipContainer = Roact.createElement(BlipContainerComponent)
		})
	})
end

function mainMinimap:didMount()
	self.updateEvent = events.Update.Event:connect(function()
		self:setState(function(state)
			return{
			}
		end)
	end)
end

function mainMinimap:willUnmount()
	self.updateEvent:Disconnect()
end

return mainMinimap
