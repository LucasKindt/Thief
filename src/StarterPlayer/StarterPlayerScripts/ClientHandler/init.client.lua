-- Variables --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")

-- Events --
local InventoryUpdated = ReplicatedStorage.Events.InventoryUpdated
local BankUpdated = ReplicatedStorage.Events.BankUpdated
local CashUpdated = ReplicatedStorage.Events.CashUpdated

-- Player --
local player = game.Players.LocalPlayer
local PlayerGUI = player.PlayerGui
local PlayerMouse = player:GetMouse()

-- MenuUI
local MenuUI = PlayerGUI:WaitForChild("Menu").Frame
--local ItemsListFrame = InventoryUI:WaitForChild("Items")
local statisticsFrame = MenuUI.statistics
local cashBox = statisticsFrame.Cash

-- Modules
local minimap = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("PlumsMinimap"))

PlayerMouse.Icon = 'rbxassetid://11514712616'
player.CameraMode = Enum.CameraMode.LockFirstPerson

local function updateInventory(inventory)
	--for _, item in ipairs(ItemsListFrame:GetChildren()) do
	--	if item.Name == 'item' then
	--		item:Destroy()
	--	end
	--end
	
	--for _, item in ipairs(inventory) do
	--	local itemBox = Instance.new('TextBox')
	--	itemBox.BorderSizePixel = 2
	--	itemBox.Text = item.name
	--	itemBox.Name = 'item'
	--	itemBox.Size = UDim2.new(0, 154 ,0 , 21)
	--	itemBox.Parent = ItemsListFrame
	--end
end

local function updateBank(bank)
	
end

local function updateCash(cash)
	cashBox.Text = cash
end

minimap:Toggle()

InventoryUpdated.OnClientEvent:Connect(updateInventory)
BankUpdated.OnClientEvent:Connect(updateBank)
CashUpdated.OnClientEvent:Connect(updateCash)