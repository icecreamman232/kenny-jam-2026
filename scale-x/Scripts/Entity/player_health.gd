class_name PlayerHealth extends Health


func take_damage(damage:int) -> void: 
	if (IngameDataManager.cheat_manager as CheatManager).is_immortal: return
	super.take_damage(damage)


func update_life(life:int):
	var ratio_current_life :float = float(current_life) / max_life
	max_life = life
	current_life = roundi(ratio_current_life * life)
	update_life_bar()


func update_life_bar():
	super.update_life_bar()
	EventBus.on_player_update_life.emit(current_life, max_life)
	
	
func kill():
	super.kill()
	(_controller as PlayerController).on_before_dead()
	EventBus.on_player_dead.emit()