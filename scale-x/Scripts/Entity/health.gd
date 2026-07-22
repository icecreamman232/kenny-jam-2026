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


func spent_life(life:int) -> void:
	if current_life <= life: return
	current_life -= life
	(_controller.stat as StatController).set_final(StatController.StatType.LIFE, current_life)
	update_life_bar()


func recover_life(life:int):
	current_life += life
	if current_life > max_life: current_life = max_life
	(_controller.stat as StatController).set_final(StatController.StatType.LIFE, current_life)
	update_life_bar()


func recover_full_life():
	current_life = max_life
	(_controller.stat as StatController).set_final(StatController.StatType.LIFE, current_life)
	update_life_bar()


func take_damage(damage:int): 
	var armor := (_controller.stat as StatController).get_final(StatController.StatType.ARMOR)
	var final_damage := damage - armor
	if final_damage < 0: final_damage = 0
	current_life -= final_damage
	if current_life < 0: current_life = 0
	update_life_bar()
	
	if current_life <= 0:
		kill()
	
		
		
func kill(): pass