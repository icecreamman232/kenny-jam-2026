class_name PlayerCellGridUi extends Control


@export var assigned_item:ItemData
@export var item_icon:TextureRect

func assign_item(item:ItemData) -> void:
	if item == null: return
	assigned_item = item
	item_icon.texture = item.item_icon
