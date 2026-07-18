class_name EnemyHealth extends Health

@export var avatar:EnemyAvatar

func update_life_bar():
	super.update_life_bar()
	EventBus.on_enemy_update_life.emit(current_life, max_life)
	
	
func kill():
	super.kill()
	var disappear_tween := avatar.disappear_icon_tween()
	await disappear_tween.finished
	EventBus.on_enemy_dead.emit()
	
	