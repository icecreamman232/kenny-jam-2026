class_name PlayerHealth extends Health


func update_life(life:int):
	var ratio_current_life :float = float(current_life) / max_life
	max_life = life
	current_life = roundi(ratio_current_life * life)
	update_life_bar()


func update_life_bar():
	super.update_life_bar()
	EventBus.on_player_update_life.emit(current_life, max_life)