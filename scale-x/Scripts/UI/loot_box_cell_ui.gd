class_name LootBoxCellUi extends TextureRect

@export var assigned_item:ItemData
@export var assigned_item_icon:TextureRect

func assign_item(item:ItemData):
	assigned_item = item
	assigned_item_icon.texture = item.item_icon
	
	
func unassign_item():
	assigned_item = null
	assigned_item_icon.texture = null


