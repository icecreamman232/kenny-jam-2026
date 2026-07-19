class_name LootManager extends Node

@export var weapon_items:Array[ItemData]
@export var armor_items:Array[ItemData]

var _all_item:Array[ItemData]
const MAX_ITEM_IN_LOOT_BOX:int = 3

const COMMON_ITEM_RANGE_VALUE:Vector2i = Vector2i(1, 3)
const UNCOMMON_ITEM_RANGE_VALUE:Vector2i = Vector2i(3, 6)
const RARE_ITEM_RANGE_VALUE:Vector2i = Vector2i(6, 8)
const LEGENDARY_ITEM_RANGE_VALUE:Vector2i = Vector2i(8, 10)
const EPIC_ITEM_RANGE_VALUE:Vector2i = Vector2i(10, 12)

const ATK_FACTOR:float = 1
const ACC_FACTOR:float = 1
const SPD_FACTOR:float = 0.5
const LIFE_FACTOR:float = 0.8
const MANA_FACTOR:float = 0.5
const DODGE_FACTOR:float = 0.25
const ARMOR_FACTOR:float = 0.25

# Rarity order: [common, uncommon, rare, epic, legendary]
const EARLY_GAME_1_RARITY_WEIGHTS:Array[float] = [1, 0 , 0 , 0 , 0]
const EARLY_GAME_2_RARITY_WEIGHTS:Array[float] = [6, 3 , 0 , 0 , 0]
const MID_GAME_1_RARITY_WEIGHTS:Array[float] = [6, 3 , 1 , 0 , 0]
const MID_GAME_2_RARITY_WEIGHTS:Array[float] = [3, 6 , 2 , 0 , 0]
const LATE_GAME_1_RARITY_WEIGHTS:Array[float] = [0, 1 , 6 , 2 , 0]
const LATE_GAME_2_RARITY_WEIGHTS:Array[float] = [1, 1 , 10 , 3  , 3]



func _ready() -> void:
	_all_item.append_array(weapon_items)
	_all_item.append_array(armor_items)


func get_items(round_number:int) -> Array[ItemData]:
	var result:Array[ItemData]
	for idx in MAX_ITEM_IN_LOOT_BOX:
		var random_item:ItemData = _all_item.pick_random()
		random_item = random_item.duplicate()
		_apply_random_stat_to_item(random_item, round_number)
		print("Item: ATK ", random_item.attack, " SPD ", random_item.speed, " LIFE ", random_item.life, " MANA ", random_item.mana, " DODGE ", random_item.dodge, " ARMOR ", random_item.armor)
		result.append(random_item)
	
	return result


func _apply_random_stat_to_item(item:ItemData, round_number:int):
	var rand_rarity:Array
	if round_number <= 2:
		rand_rarity = get_random_rarities(3, EARLY_GAME_1_RARITY_WEIGHTS)
	elif round_number <= 5:
		rand_rarity = get_random_rarities(3, EARLY_GAME_2_RARITY_WEIGHTS)
	elif round_number <= 8:
		rand_rarity = get_random_rarities(3, MID_GAME_1_RARITY_WEIGHTS)
	elif round_number <= 11:
		rand_rarity = get_random_rarities(3, MID_GAME_2_RARITY_WEIGHTS)
	elif round_number <= 15:
		rand_rarity = get_random_rarities(3, LATE_GAME_1_RARITY_WEIGHTS)
	elif round_number > 15:
		rand_rarity = get_random_rarities(3, LATE_GAME_2_RARITY_WEIGHTS)
	
	var chosen_rarity:ItemData.ItemRarity = rand_rarity.pick_random()
	item.rarity = chosen_rarity

	for idx in range(item.stats.size()):
		var stat_value := _get_random_stat_value(chosen_rarity)
		match item.stats[idx]:
			StatController.StatType.ATTACK:
				item.attack = _get_random_attack(stat_value)
			StatController.StatType.ACCURACY:
				item.accuracy = _get_random_accuracy(stat_value)
			StatController.StatType.SPEED:
				item.speed = _get_random_speed(stat_value)
			StatController.StatType.LIFE:
				item.life = _get_random_life(stat_value)
			StatController.StatType.MANA:
				item.mana = _get_random_mana(stat_value)
			StatController.StatType.DODGE:
				item.dodge = _get_random_dodge(stat_value)
			StatController.StatType.ARMOR:
				item.armor = _get_random_armor(stat_value)


## weights order must match Rarity enum: [common, uncommon, rare, epic, legendary]
## e.g. get_random_rarities(10, [50.0, 30.0, 15.0, 4.0, 1.0])
func get_random_rarities(count: int, weights: Array[float]) -> Array[ItemData.ItemRarity]:
	if weights.size() != ItemData.ItemRarity.size():
		push_error("weights.size() must equal %d, got %d" % [ItemData.ItemRarity.size(), weights.size()])
		return []

	var total_weight := 0.0
	for w in weights:
		total_weight += w
	if total_weight <= 0.0:
		push_error("weights must sum to > 0")
		return []

	# precompute cumulative thresholds once, not per-roll
	var cumulative: Array[float] = []
	var running := 0.0
	for w in weights:
		running += w
		cumulative.append(running)

	var result: Array[ItemData.ItemRarity] = []
	result.resize(count)
	for i in count:
		var roll := randf_range(0.0, total_weight)
		for r in cumulative.size():
			if roll <= cumulative[r]:
				result[i] = r as ItemData.ItemRarity
				break

	return result




func _get_random_stat_value(rarity:ItemData.ItemRarity) ->int:
	match rarity:
		ItemData.ItemRarity.COMMON:
			return randi_range(COMMON_ITEM_RANGE_VALUE[0], COMMON_ITEM_RANGE_VALUE[1])
		ItemData.ItemRarity.UNCOMMON:
			return randi_range(UNCOMMON_ITEM_RANGE_VALUE[0], UNCOMMON_ITEM_RANGE_VALUE[1])
		ItemData.ItemRarity.RARE:
			return randi_range(RARE_ITEM_RANGE_VALUE[0], RARE_ITEM_RANGE_VALUE[1])
		ItemData.ItemRarity.LEGENDARY:
			return randi_range(LEGENDARY_ITEM_RANGE_VALUE[0], LEGENDARY_ITEM_RANGE_VALUE[1])
		ItemData.ItemRarity.EPIC:
			return randi_range(EPIC_ITEM_RANGE_VALUE[0], EPIC_ITEM_RANGE_VALUE[1])
	return 0



func _get_random_attack(stat_value:int) ->int:
	return roundi(stat_value * ATK_FACTOR)
	

func _get_random_speed(stat_value:int) ->int:
	return roundi(stat_value * SPD_FACTOR)
	
func _get_random_accuracy(stat_value:int) ->int:
	return roundi(stat_value * ACC_FACTOR)	
	

func _get_random_life(stat_value:int) ->int:
	return roundi(stat_value * LIFE_FACTOR)
	

func _get_random_mana(stat_value:int) ->int:
	return roundi(stat_value * MANA_FACTOR)
	
	
func _get_random_armor(stat_value:int) ->int:
	return roundi(stat_value * ARMOR_FACTOR)
	

func _get_random_dodge(stat_value:int) ->int:
	return roundi(stat_value * DODGE_FACTOR)
