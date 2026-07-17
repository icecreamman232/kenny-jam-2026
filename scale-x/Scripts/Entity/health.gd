class_name Health extends Node

@export var current_life:int
@export var max_life:int

func initialize_health(life:int) ->void:
	max_life = life
	current_life = life
	
	
func update_life_bar(): pass