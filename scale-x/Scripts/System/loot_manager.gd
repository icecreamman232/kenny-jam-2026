class_name LootManager extends Node

@export var weapon_items:Array[ItemData]
@export var armor_items:Array[ItemData]

var _all_item:Array[ItemData]
const MAX_ITEM_IN_LOOT_BOX:int = 3

func _ready() -> void:
	_all_item.append_array(weapon_items)
	_all_item.append_array(armor_items)


func get_items() -> Array[ItemData]:
	var result:Array[ItemData]
	for idx in MAX_ITEM_IN_LOOT_BOX:
		var random_item:ItemData = _all_item.pick_random()
		result.append(random_item.duplicate())
	
	return result
