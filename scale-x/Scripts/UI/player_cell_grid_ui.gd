class_name PlayerCellGridUi extends Control

@export var grid_index:int
@export var assigned_item:ItemData
@export var item_icon:TextureRect

func assign_item(item:ItemData) -> void:
	if item == null: return
	assigned_item = item
	item_icon.texture = item.item_icon
	item_icon.self_modulate = Helper.get_color_by_rarity(item.rarity)
	

func unassign_item() -> void:
	if assigned_item == null: return
	assigned_item = null
	item_icon.self_modulate = Color.WHITE
	item_icon.texture = null
	

func handle_drag(is_dragging:bool = false):
	item_icon.visible = !is_dragging
	