class_name CoinHud extends RichTextLabel

var current_coin:int = 0


func initialize():
	var bonus_coin := 3 if IngameDataManager.menu_reward_id == 0 else 0
	_update_coin(Constant.STARTING_COINS + bonus_coin)
	EventBus.on_coin_change.connect(_update_coin)
	EventBus.on_player_dead.connect(_reset_coin)	
	
	
func _exit_tree() -> void:
	EventBus.on_player_dead.disconnect(_reset_coin)
	EventBus.on_coin_change.disconnect(_update_coin)


func _reset_coin():
	current_coin = Constant.STARTING_COINS
	text = "[img=24]uid://de3k1fl4j5llo[/img]" + str(current_coin).pad_decimals(0)		
	
	
func _update_coin(coin:int):
	current_coin += coin
	if current_coin < 0: current_coin = 0
	text = "[img=24]uid://de3k1fl4j5llo[/img]" + str(current_coin).pad_decimals(0)
	
	
func force_update_visual():
	text = "[img=24]uid://de3k1fl4j5llo[/img]" + str(current_coin).pad_decimals(0)
