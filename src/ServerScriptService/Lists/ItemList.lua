---- Dependancies ----
local ServerStorage = game:GetService("ServerStorage")
local ItemModels = ServerStorage.ItemModels

local ItemsModule = {
	["TableLamp"] = {
		Name = "Table Lamp";
		Type = "Tool";
		Weight = 1;
		Model = ItemModels.TableLamp;
		Price = 50;
		Stackable = false;
		Droppable = false;
		Description = 'A beautiful lamp';
	},
	["ComputerLowEnd"] = {
		Name = "Low End Computer";
		Type = "Tool";
		Weight = 1;
		Model = ItemModels.TableLamp;
		Price = 250;
		Stackable = false;
		Droppable = false;
		Description = 'A nice computer';
	},
	["KeyboardLowEnd"] = {
		Name = "Low End Keyboard";
		Type = "Tool";
		Weight = 1;
		Model = ItemModels.TableLamp;
		Price = 75;
		Stackable = false;
		Droppable = false;
		Description = 'A beautiful keyboard';
	},
	["MouseLowEnd"] = {
		Name = "Low End Mouse";
		Type = "Tool";
		Weight = 1;
		Model = ItemModels.TableLamp;
		Price = 50;
		Stackable = false;
		Droppable = false;
		Description = 'A mouse';
	},
	["SmartTV"] = {
		Name = "Table Lamp";
		Type = "Tool";
		Weight = 1;
		Model = ItemModels.TableLamp;
		Price = 300;
		Stackable = false;
		Droppable = false;
		Description = 'A beautiful TV';
	},
	["Cash50"] = {
		Name = "$50";
		Type = "Cash";
		Price = 50;
	},
	["Cash25"] = {
		Name = "$25";
		Type = "Cash";
		Price = 25;
	}
}

return ItemsModule
