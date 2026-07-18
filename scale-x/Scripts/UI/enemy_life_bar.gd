class_name EnemyLifeBar extends ProgressBar

func _ready():
	EventBus.on_enemy_update_life.connect(_on_enemy_update_life)
	
func _exit_tree() -> void:
	EventBus.on_enemy_update_life.disconnect(_on_enemy_update_life)
	
	
func _on_enemy_update_life(current_life:int, max_life:int):
	value = current_life
	max_value = max_life
