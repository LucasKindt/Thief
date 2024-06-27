local MapModule = {}
local properties = workspace:WaitForChild("Properties")
local HouseItems = require(game:GetService("ServerScriptService").Lists.HouseItems)
local PlayerDataModule = require(game:GetService("ServerScriptService").Modules.PlayerDataModule)
local players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SFX = script.SFX

function MapModule.initMap(player)
	for i,v in ipairs(properties:GetChildren()) do
		local items = HouseItems[v.Name]
		local loadedItems = v:WaitForChild("LoadedItems")
		-- Load all models
		for i1,v1 in pairs(items) do
			local item = game.ServerStorage.ItemModels:FindFirstChild(i1)
			if item then
				local houseName = v.Name
				local itemName = i1
				local itemId = v1.id

				if PlayerDataModule.CheckStolen(player, houseName, itemName, itemId) then
					continue
				end
				local newItem = item:Clone()
				local Hitbox = newItem.hitbox

				Hitbox:setAttribute('house',houseName)
				Hitbox:setAttribute('name', itemName)
				Hitbox:setAttribute('id', itemId)
				newItem.Parent = loadedItems
				newItem:PivotTo(CFrame.new(v1.Position) * CFrame.Angles(math.rad(v1.Orientation.X), math.rad(v1.Orientation.Y), math.rad(v1.Orientation.Z)))
			end
		end
		
		MapModule.initWindows(player)
	end
end

function MapModule.initWindows(player)
	local WindowSound = SFX.Window

	for i, property in pairs(workspace.Properties:GetChildren()) do
		for i, window in pairs(property.Windows:GetChildren()) do
			if window:GetAttribute("Window2") then
				local open = false
				local debounce = false
				
				local main = window:FindFirstChild('Main')
				local main2 = window:FindFirstChild('Main2')
				local hinge = window:FindFirstChild('Hinge')
				local prompt = main.ProxPrompt
				local prompt2 = main2.ProxPrompt
				
				local enterPrompt = window:FindFirstChild('Passthrough').ProxPrompt
				
				-- Teleports
				local outsidePart = window.Teleports.Outside
				local insidePart = window.Teleports.Inside
				
				local currentCFrame = hinge.CFrame

				local Goal
				local tweenInfo = TweenInfo.new(.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
				
				local function promptTrigger()
					if debounce == false then
						debounce = true
						if open == false then -- Window opening --
							open = true
							prompt.ActionText = 'Close'
							prompt2.ActionText = 'Close'
							enterPrompt.Enabled = true
							Goal = {CFrame = currentCFrame + Vector3.new(0, 2.37, 0)}
							WindowSound:Play()
						else -- Window closing --
							open = false
							prompt.ActionText = 'Open'
							prompt2.ActionText = 'Open'
							enterPrompt.Enabled = false
							Goal = {CFrame = currentCFrame + Vector3.new(0, 0, 0)}
							WindowSound:Play()
						end

						local tween = TweenService:Create(hinge, tweenInfo, Goal)
						tween:Play()
						tween.Completed:Wait()
						debounce = false
					end
				end
				
				local function enterTrigger()
					if debounce == false then
						debounce = true
						
						local closestPart = nil
						local closestMagnitude = math.huge
						
						local HumanoidRoot = player.Character.HumanoidRootPart
						
						if open == true then
							if (insidePart.Position - HumanoidRoot.Position).Magnitude < closestMagnitude then
								closestMagnitude = (insidePart.Position - HumanoidRoot.Position).Magnitude
								closestPart = outsidePart
							end
							if (outsidePart.Position - HumanoidRoot.Position).Magnitude < closestMagnitude then
								closestMagnitude = (outsidePart.Position - HumanoidRoot.Position).Magnitude
								closestPart = insidePart
							end
							player.Character:MoveTo(closestPart.Position)
						end
						
						debounce = false
					end
				end

				prompt.Triggered:Connect(promptTrigger)
				prompt2.Triggered:Connect(promptTrigger)
				enterPrompt.Triggered:Connect(enterTrigger)
			end
		end
	end
end

return MapModule
