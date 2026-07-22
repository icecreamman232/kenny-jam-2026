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

# Rarity order: [common, uncommon, rare, epic, legendary]
const EARLY_GAME_1_RARITY_WEIGHTS:Array[float] = [1, 0 , 0 , 0 , 0]
const EARLY_GAME_2_RARITY_WEIGHTS:Array[float] = [6, 3 , 0 , 0 , 0]
const MID_GAME_1_RARITY_WEIGHTS:Array[float] = [6, 3 , 1 , 0 , 0]
const MID_GAME_2_RARITY_WEIGHTS:Array[float] = [3, 6 , 2 , 0 , 0]
const LATE_GAME_1_RARITY_WEIGHTS:Array[float] = [0, 1 , 6 , 2 , 0]
const LATE_GAME_2_RARITY_WEIGHTS:Array[float] = [1, 1 , 10 , 3  , 3]

const EARLY_ITEM_TYPE_WEIGHT:Array = [
	["weapon", "weapon", "armor"],
	["weapon", "armor", "armor"],
	["weapon", "weapon", "weapon"]
]


func _ready() -> void:
	_all_item.append_array(weapon_items)
	_all_item.append_array(armor_items)


func get_items(round_number:int) -> Array[ItemData]:
	var result:Array[ItemData]
	
	if round_number <= 3:
		result = _pick_item_for_early_game()
		for idx in range(result.size()):
			_apply_random_stat_to_item(result[idx], round_number)
	else:
		for idx in MAX_ITEM_IN_LOOT_BOX:
			var random_item:ItemData = _all_item.pick_random()
			random_item = random_item.duplicate()
			_apply_random_stat_to_item(random_item, round_number)
			#print("Item: ATK ", random_item.attack, " SPD ", random_item.speed, " LIFE ", random_item.life, " MANA ", random_item.mana, " DODGE ", random_item.dodge, " ARMOR ", random_item.armor)
			result.append(random_item)
	
	return result


func _pick_item_for_early_game()->Array[ItemData]:
	var result:Array[ItemData] = []
	var rand_weight:Array = EARLY_ITEM_TYPE_WEIGHT.pick_random()
	for weight in rand_weight:
		if weight == "weapon":
			result.append(weapon_items.pick_random().duplicate())
		elif weight == "armor":
			result.append(armor_items.pick_random().duplicate())
	return result
	


func _apply_random_stat_to_item(item:ItemData, round_number:int):
	var rand_rarity:Array
	if round_number <= Constant.EARLY_GAME_1_ROUND_NUMBER:
		rand_rarity = get_random_rarities(3, EARLY_GAME_1_RARITY_WEIGHTS)
	elif round_number <= Constant.EARLY_GAME_2_ROUND_NUMBER:
		rand_rarity = get_random_rarities(3, EARLY_GAME_2_RARITY_WEIGHTS)
	elif round_number <= Constant.MID_GAME_1_ROUND_NUMBER:
		rand_rarity = get_random_rarities(3, MID_GAME_1_RARITY_WEIGHTS)
	elif round_number <= Constant.MID_GAME_2_ROUND_NUMBER:
		rand_rarity = get_random_rarities(3, MID_GAME_2_RARITY_WEIGHTS)
	elif round_number <= Constant.LATE_GAME_ROUND_NUMBER:
		rand_rarity = get_random_rarities(3, LATE_GAME_1_RARITY_WEIGHTS)
	elif round_number > Constant.LATE_GAME_ROUND_NUMBER:
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
				
	# Add modifier if item is not common
	#if item.rarity == ItemData.ItemRarity.COMMON: return
	if item.modifier_pool.size() == 0: return
	item.modifier_list.clear()
	var rand_ix := randi_range(0, item.modifier_pool.size() - 1)
	var rand_mod_id:Modifier.ModifierId = item.modifier_pool[rand_ix]
	var modifier:Modifier = ModifierFactory.create_modifier(rand_mod_id)
	if modifier != null:
		item.modifier_list.append(modifier)			


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
	return roundi(stat_value * Constant.ITEM_ATK_FACTOR)
	

func _get_random_speed(stat_value:int) ->int:
	return roundi(stat_value * Constant.ITEM_SPD_FACTOR)
	
func _get_random_accuracy(stat_value:int) ->int:
	return roundi(stat_value * Constant.ITEM_ACC_FACTOR)	
	

func _get_random_life(stat_value:int) ->int:
	return roundi(stat_value * Constant.ITEM_LIFE_FACTOR)
	

func _get_random_mana(stat_value:int) ->int:
	return roundi(stat_value * Constant.ITEM_MANA_FACTOR)
	
	
func _get_random_armor(stat_value:int) ->int:
	return roundi(stat_value * Constant.ITEM_ARMOR_FACTOR)
	

func _get_random_dodge(stat_value:int) ->int:
	return roundi(stat_value * Constant.ITEM_DODGE_FACTOR)
