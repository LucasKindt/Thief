local DataStore2 = require(game:GetService("ServerScriptService").Services.DataService)
local InventoryUpdated = game:GetService("ReplicatedStorage").Events.InventoryUpdated
local BankUpdated = game:GetService("ReplicatedStorage").Events.BankUpdated
local CashUpdated = game:GetService("ReplicatedStorage").Events.CashUpdated
local ItemList = require(game:GetService("ServerScriptService").Lists.ItemList)
local HouseItems = require(game:GetService("ServerScriptService").Lists.HouseItems)

-- Define the keys for DataStore2
local CASH_KEY = "CASH"
local BANK_KEY = "BANK"
local INVENTORY_KEY = "INVENTORY"
local HOUSES_KEY = "HOUSES"

local Stolen_reset_time = 3600  -- Stolen items reset after 1 hour

local PlayerDataModule = {}

-- Function to initialize DataStore2 for a player
function PlayerDataModule.InitPlayerData(player:Player)
	DataStore2.Combine("DEV_7_DATA", CASH_KEY, BANK_KEY, INVENTORY_KEY, HOUSES_KEY)

	local cashStore = DataStore2(CASH_KEY, player)
	local bankStore = DataStore2(BANK_KEY, player)
	local inventoryStore = DataStore2(INVENTORY_KEY, player)
	local housesStore = DataStore2(HOUSES_KEY, player)

	-- Set default values if not already set
	if not cashStore:Get(nil) then
		cashStore:Set(0)
	end
	if not bankStore:Get(nil) then
		bankStore:Set(0)
	end
	if not inventoryStore:Get(nil) then
		inventoryStore:Set({})
	end
	if not housesStore:Get(nil) then
		housesStore:Set({})
	end

	InventoryUpdated:FireClient(player, inventoryStore:Get({}))
	CashUpdated:FireClient(player, cashStore:Get(0))
	BankUpdated:FireClient(player, bankStore:Get(0))
end

-- Function to get player cash
function PlayerDataModule.GetCash(player:Player)
	local cashStore = DataStore2(CASH_KEY, player)
	return cashStore:Get(0)
end

-- Function to update player cash
function PlayerDataModule.UpdateCash(player:Player, amount)
	local cashStore = DataStore2(CASH_KEY, player)
	cashStore:Increment(amount)
	CashUpdated:FireClient(player, cashStore:Get(0))
end

-- Function to get player bank balance
function PlayerDataModule.GetBank(player:Player)
	local bankStore = DataStore2(BANK_KEY, player)
	return bankStore:Get(0)
end

-- Function to update player bank balance
function PlayerDataModule.UpdateBank(player:Player, amount)
	local bankStore = DataStore2(BANK_KEY, player)
	bankStore:Increment(amount)
	BankUpdated:FireClient(player, bankStore:Get(0))
end

-- Function to get player inventory
function PlayerDataModule.GetInventory(player:Player)
	local inventoryStore = DataStore2(INVENTORY_KEY, player)
	return inventoryStore:Get({})
end

-- Function to add item to inventory
function PlayerDataModule.AddItem(player:Player, itemType, itemName)
	local inventoryStore = DataStore2(INVENTORY_KEY, player)
	local inventory = inventoryStore:Get({})
	table.insert(inventory, {type = itemType, name = itemName})
	inventoryStore:Set(inventory) 
	InventoryUpdated:FireClient(player, inventory)
end

-- Function to remove item from inventory
function PlayerDataModule.RemoveItem(player:Player, itemName)
	local inventoryStore = DataStore2(INVENTORY_KEY, player)
	local inventory = inventoryStore:Get({})
	for i, item in ipairs(inventory) do
		if item.name == itemName then
			table.remove(inventory, i)
			break
		end
	end
	inventoryStore:Set(inventory)
	InventoryUpdated:FireClient(player, inventory)
end

function PlayerDataModule.CheckStolen(player:Player, house:string, itemName:string, itemID:string)
	local housesStore = DataStore2(HOUSES_KEY, player)
	local housesData = housesStore:Get({})

	local house = tostring(house)
	local itemName = tostring(itemName)
	local itemID = tostring(itemID)

	for i,v in pairs(housesData) do
		if i == house then
			for i1,v1 in pairs(v) do
				if i1 == itemName then
					for i2, v2 in pairs(v1) do
						if i2 == itemID then
							if (os.time() - v2) >= Stolen_reset_time then
								PlayerDataModule.SetUnstolen(player, house, itemName, itemID)
								return false
							end
							return true
						else
							continue
						end
					end
				else
					continue
				end
			end	
		else
			continue
		end
	end

	return false
end

function PlayerDataModule.SetUnstolen(player:Player, house:string, itemName:string, itemID:string)
	local housesStore = DataStore2(HOUSES_KEY, player)
	local housesData = housesStore:Get({})
	table.remove(housesData[house][itemName], itemID)
	housesStore:Set(housesData)
end

function PlayerDataModule.SetStolen(player:Player, house:string, itemName:string, itemID:string)
	local housesStore = DataStore2(HOUSES_KEY, player)
	local housesData = housesStore:Get({})

	local house = tostring(house)
	local itemName = tostring(itemName)
	local itemID = tostring(itemID)

	if not housesData[house] then
		housesData[house] = {}
	end
	if not housesData[house][itemName] then
		housesData[house][itemName] = {}
	end

	housesData[house][itemName][itemID] = os.time()
	housesStore:Set(housesData)
end

function PlayerDataModule.StealItem(player:Player, itemObject, house:string, itemName:string, itemID)
	local housesStore = DataStore2(HOUSES_KEY, player)

	if not PlayerDataModule.CheckStolen(player, house, itemName, itemID) then
		if ItemList[itemName] then
			local ItemInList = ItemList[itemName]

			PlayerDataModule.SetStolen(player, house, itemName, itemID)

			if ItemInList.Type == 'Cash' then
				PlayerDataModule.UpdateCash(player, ItemInList.Price)
			elseif ItemInList.Type == 'Mission' then
				-- mission completed or something
			else
				PlayerDataModule.AddItem(player, ItemList[itemName].Type, itemName)
			end

			itemObject:Destroy()
			return true
		end
	end

	return false
end

return PlayerDataModule