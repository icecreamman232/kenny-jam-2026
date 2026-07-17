class_name LootBoxUI extends Control

@export var loot_manager:LootManager
@export var loot_box_cell_ui:Array[LootBoxCellUi]


func show_loot():
	var loot_items:= loot_manager.get_items()
	for idx in range(loot_items.size()):
		loot_box_cell_ui[idx].assign_item(loot_items[idx])

