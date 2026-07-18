class_name PlayerLifeBar extends ProgressBar

@export var life_label:Label

func _ready():
	value = max_value
	EventBus.on_player_update_life.connect(_on_player_update_life)
	
func _exit_tree() -> void:
	EventBus.on_player_update_life.disconnect(_on_player_update_life)
	

func _on_player_update_life(current_life:int, max_life:int):
	max_value = max_life
	value = current_life
	life_label.text = str(current_life) + "/" + str(max_life)
