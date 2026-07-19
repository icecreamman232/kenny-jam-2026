class_name CoinHud extends RichTextLabel

var current_coin:int = 0

func _ready():
	EventBus.on_coin_change.connect(_update_coin)
	_update_coin(Constant.STARTING_COINS)
	
	
func _exit_tree() -> void:
	EventBus.on_coin_change.disconnect(_update_coin)
	
	
func _update_coin(coin:int):
	current_coin += coin
	text = "[img=24]uid://de3k1fl4j5llo[/img]" + str(current_coin).pad_decimals(0)
