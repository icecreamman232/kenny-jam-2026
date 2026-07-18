class_name EnemyLifeBar extends ProgressBar

@export var life_label:Label

func _ready():
	EventBus.on_enemy_update_life.connect(_on_enemy_update_life)
	
func _exit_tree() -> void:
	EventBus.on_enemy_update_life.disconnect(_on_enemy_update_life)
	
	
func _on_enemy_update_life(current_life:int, max_life:int):
	value = current_life
	max_value = max_life
	life_label.text = str(current_life) + "/" + str(max_life)
	

