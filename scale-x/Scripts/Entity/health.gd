class_name Health extends Node

@export var current_life:int
@export var max_life:int

func initialize_health(life:int) ->void:
	max_life = life
	current_life = life
	update_life_bar()

	
	
func update_life_bar(): pass


func take_damage(damage:int): 
	current_life -= damage
	if current_life < 0: current_life = 0
	update_life_bar()
	
	if current_life <= 0:
		kill()
	
		
		
func kill(): pass