class_name StatMasterShop extends Control

@export var reroll_price_label:RichTextLabel
@export var reroll_button:Button
@export var player_coin_label:RichTextLabel
@export var close_button:Button
@export var stat_slots:Array[StatMasterSlot]
@export var icon_for_stat:Dictionary[StatController.StatType,Texture2D]

var stat_to_buy:Array[StatController.StatType] = []
var _reroll_count_time:int = 0
var _current_reroll_price:int = 0

const STARTING_SLOT_PRICE:int = 10
const SLOT_PRICE_INCREASE_PER_TIME:int = 10
const STARTING_REROLL_PRICE:int = 15
const REROLL_PRICE_INCREASE_PER_TIME:int = 10 

const STAT_TYPE_ARRAY:Array[StatController.StatType] = [
	StatController.StatType.ATTACK,
	StatController.StatType.ACCURACY,
	StatController.StatType.SPEED,
	StatController.StatType.LIFE,
	StatController.StatType.DODGE,
	StatController.StatType.ARMOR,
]

const PRICE_FACTOR_BY_STAT_TYPE:Dictionary[StatController.StatType,float] = {
	StatController.StatType.ATTACK: 2,
	StatController.StatType.ACCURACY: 1.2,
	StatController.StatType.SPEED: 1.5,
	StatController.StatType.LIFE: 1,
	StatController.StatType.DODGE: 1.5,
	StatController.StatType.ARMOR: 2,
}


func _ready():
	close_button.pressed.connect(_on_close_button_pressed)
	reroll_button.pressed.connect(_on_reroll_button_pressed)
	EventBus.on_open_npc_shop.connect(_on_open_npc_shop)
	
	
func _exit_tree() -> void:
	close_button.pressed.disconnect(_on_close_button_pressed)
	reroll_button.pressed.disconnect(_on_reroll_button_pressed)
	EventBus.on_open_npc_shop.disconnect(_on_open_npc_shop)
	
	
func _on_close_button_pressed():
	hide()


func _on_reroll_button_pressed() -> void:
	if IngameDataManager.coin_hud.current_coin < _current_reroll_price: return
	
	_reroll_count_time += 1
	EventBus.on_coin_change.emit(-_current_reroll_price)
	
	_current_reroll_price += REROLL_PRICE_INCREASE_PER_TIME
	reroll_price_label.text = "[img=24]uid://de3k1fl4j5llo[/img]" + str(_current_reroll_price) 
	
	stat_to_buy.clear()
	var lowest_stat: StatController.StatType = _get_stat_that_player_has_lowest_value()
	stat_to_buy.append(STAT_TYPE_ARRAY.pick_random())
	stat_to_buy.append(STAT_TYPE_ARRAY.pick_random())
	stat_to_buy.append(lowest_stat)
	
	for idx in range(stat_slots.size()):
		stat_slots[idx].show_slot(icon_for_stat[stat_to_buy[idx]], _get_price_for_stat(stat_to_buy[idx]), stat_to_buy[idx])
	
	
	
func _on_open_npc_shop(npc_id:NpcManager.NpcID) -> void:
	if npc_id != NpcManager.NpcID.STAT_MASTER: return
	
	_current_reroll_price = STARTING_REROLL_PRICE
	_reroll_count_time = 0
	player_coin_label.text = "[img=32 align=center,center]uid://de3k1fl4j5llo[/img]" + str(IngameDataManager.coin_hud.current_coin)
	reroll_price_label.text = "[img=24]uid://de3k1fl4j5llo[/img]" + str(STARTING_REROLL_PRICE)
	
	var lowest_stat: StatController.StatType = _get_stat_that_player_has_lowest_value()
	stat_to_buy.append(STAT_TYPE_ARRAY.pick_random())
	stat_to_buy.append(STAT_TYPE_ARRAY.pick_random())
	stat_to_buy.append(lowest_stat)
	
	for idx in range(stat_slots.size()):
		stat_slots[idx].show_slot(icon_for_stat[stat_to_buy[idx]], _get_price_for_stat(stat_to_buy[idx]), stat_to_buy[idx])

	show()


func _get_price_for_stat(stat_type:StatController.StatType) -> int:
	var final_price:int = STARTING_REROLL_PRICE
	var added_by_reroll_time:int = _reroll_count_time * SLOT_PRICE_INCREASE_PER_TIME
	final_price = roundi(final_price * PRICE_FACTOR_BY_STAT_TYPE[stat_type])
	final_price += added_by_reroll_time
	return final_price


func _get_stat_that_player_has_lowest_value() -> StatController.StatType:
	var player: PlayerController = IngameDataManager.gameplay_manager.player_controller
	
	var stats := {
		StatController.StatType.ATTACK: player.stat.get_final(StatController.StatType.ATTACK),
		StatController.StatType.ACCURACY: player.stat.get_final(StatController.StatType.ACCURACY),
		StatController.StatType.SPEED: player.stat.get_final(StatController.StatType.SPEED),
		StatController.StatType.LIFE: player.stat.get_final(StatController.StatType.LIFE),
		StatController.StatType.DODGE: player.stat.get_final(StatController.StatType.DODGE),
		StatController.StatType.ARMOR: player.stat.get_final(StatController.StatType.ARMOR),
	}

	var lowest_stat: StatController.StatType = stats.keys()[0]
	var lowest_value: float = stats[lowest_stat]

	for stat_type in stats:
		if stats[stat_type] < lowest_value:
			lowest_value = stats[stat_type]
			lowest_stat = stat_type

	return lowest_stat


func request_to_buy_stat(stat_type:StatController.StatType, price:int, slot:StatMasterSlot) -> void:
	if IngameDataManager.coin_hud.current_coin < price: return
	EventBus.on_coin_change.emit(-price)
	var player := IngameDataManager.gameplay_manager.player_controller as PlayerController
	var current_stat_value:= player.stat.get_final(stat_type)
	current_stat_value += 1
	player.stat.set_final(stat_type, current_stat_value)
	EventBus.update_player_info.emit(player.stat)
	# Change visual that the slot is sold out
	slot.sold_out()
	
