local Players = game:GetService("Players")
local DataStore2 = require(game.ServerScriptService.Modules.DataStore2)

-- Define the DataStore key for storing stolen item states
local ITEM_STATE_KEY = "StolenItems"

-- Function to mark an item as stolen
local function markItemAsStolen(player, itemId)
    local itemDataStore = DataStore2(ITEM_STATE_KEY, player)
    local stolenItems = itemDataStore:Get({}) -- Get the current list of stolen items, default to an empty table

    -- Add the itemId to the stolen items list if it's not already there
    local itemAlreadyStolen = false
    for i, id in stolenItems do
        if id == itemId then
            itemAlreadyStolen = true
            break
        end
    end

    if not itemAlreadyStolen then
        table.insert(stolenItems, itemId)
        itemDataStore:Set(stolenItems)
    end
end

-- Function to check if an item is stolen
local function isItemStolen(player, itemId)
    local itemDataStore = DataStore2(ITEM_STATE_KEY, player)
    local stolenItems = itemDataStore:Get({}) -- Get the current list of stolen items, default to an empty table

    for i, id in stolenItems do
        if id == itemId then
            return true
        end
    end
    return false
end

-- Event handler for when a player tries to loot an item
local function onPlayerLootItem(player, itemId)
    if isItemStolen(player, itemId) then
        -- Prevent looting if the item is marked as stolen
        print("Item " .. itemId .. " is stolen and cannot be looted.")
        return false
    else
        -- Allow looting and mark the item as stolen
        markItemAsStolen(player, itemId)
        print("Item " .. itemId .. " has been looted and marked as stolen.")
        return true
    end
end

-- Bind the event handler to the PlayerAdded event and existing players
game.Players.PlayerAdded:Connect(function(player)
    -- Example: Connect the onPlayerLootItem function to a custom event
    -- Replace 'LootItemEvent' with the actual event name
    game.ReplicatedStorage.Events.LootItemEvent.OnServerEvent:Connect(function(player, itemId)
        onPlayerLootItem(player, itemId)
    end)
end)

for _, player in Players:GetPlayers() do
    -- Example: Connect the onPlayerLootItem function to a custom event
    -- Replace 'LootItemEvent' with the actual event name
    game.ReplicatedStorage.Events.LootItemEvent.OnServerEvent:Connect(function(player, itemId)
        onPlayerLootItem(player, itemId)
    end)
end