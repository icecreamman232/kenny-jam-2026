class_name Health extends Node

@export var current_life:int
@export var max_life:int
var _controller:EntityController

func initialize_health(controller:EntityController) ->void:
	_controller = controller
	max_life = (_controller.stat as StatController).get_final(StatController.StatType.LIFE)
	current_life = max_life
	update_life_bar()

	
func update_life_bar(): pass


func recover_full_life():
	current_life = max_life
	(_controller.stat as StatController).set_final(StatController.StatType.LIFE, current_life)
	update_life_bar()


func take_damage(damage:int): 
	current_life -= damage
	if current_life < 0: current_life = 0
	update_life_bar()
	
	if current_life <= 0:
		kill()
	
		
		
func kill(): pass