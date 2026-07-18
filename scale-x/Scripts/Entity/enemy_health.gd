class_name EnemyHealth extends Health


func update_life_bar():
	super.update_life_bar()
	EventBus.on_enemy_update_life.emit(current_life, max_life)
