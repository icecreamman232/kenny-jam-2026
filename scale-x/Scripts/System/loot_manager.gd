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
		random_item = random_item.duplicate()
		_apply_random_stat_to_item(random_item)
		print("Item: ATK", random_item.attack, " SPD", random_item.speed, " LIFE", random_item.life, " MANA", random_item.mana, " DODGE", random_item.dodge, " ARMOR", random_item.armor)
		result.append(random_item)
	
	return result


func _apply_random_stat_to_item(item:ItemData):
	for idx in range(item.stats.size()):
		match item.stats[idx]:
			StatController.StatType.ATTACK:
				item.attack = _get_random_attack()
			StatController.StatType.SPEED:
				item.speed = _get_random_speed()
			StatController.StatType.LIFE:
				item.life = _get_random_life()
			StatController.StatType.MANA:
				item.mana = _get_random_mana()
			StatController.StatType.DODGE:
				item.dodge = _get_random_dodge()
			StatController.StatType.ARMOR:
				item.armor = _get_random_armor()


func _get_random_attack() ->int:
	return randi_range(0, 10)
	

func _get_random_speed() ->int:
	return randi_range(0, 10)
	

func _get_random_life() ->int:
	return randi_range(0, 10)
	

func _get_random_mana() ->int:
	return randi_range(0, 10)
	
	
func _get_random_armor() ->int:
	return randi_range(0, 10)
	

func _get_random_dodge() ->int:
	return randi_range(0, 10)
