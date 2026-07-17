class_name PlayerHealth extends Health


func update_life_bar():
	super.update_life_bar()
	EventBus.on_player_update_life.emit(current_life, max_life)