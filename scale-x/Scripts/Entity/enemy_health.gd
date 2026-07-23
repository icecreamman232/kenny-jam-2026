class_name EnemyHealth extends Health

@export var avatar:EnemyAvatar


func take_damage(damage:int) -> void:
	if (IngameDataManager.cheat_manager as CheatManager).is_always_execute:
		current_life = 0
		kill()
		return 
	super.take_damage(damage)


func update_life_bar():
	super.update_life_bar()
	EventBus.on_enemy_update_life.emit(current_life, max_life)
	
	
func kill():
	super.kill()
	(_controller as EnemyController).on_before_dead()
	var disappear_tween := avatar.disappear_icon_tween()
	await disappear_tween.finished
	EventBus.on_enemy_dead.emit()
	
	