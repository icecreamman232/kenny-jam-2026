class_name LootBoxCellUi extends TextureRect

@export var assigned_item:ItemData
@export var assigned_item_icon:TextureRect

func handle_drag(is_dragging:bool):
	assigned_item_icon.visible = !is_dragging


func assign_item(item:ItemData):
	assigned_item = item
	assigned_item_icon.texture = item.item_icon
	assigned_item_icon.self_modulate = Helper.get_color_by_rarity(item.rarity)	
	
	
func unassign_item():
	assigned_item = null
	assigned_item_icon.texture = null


