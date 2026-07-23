class_name EnemyManager extends Node

@export var player_controller:PlayerController
@export var enemy_data_list:Array[EnemyData]
@export var boss_list:Array[EnemyData]


func get_boss(round_number:int) -> EnemyData:
	var source_data = boss_list.pick_random()
	source_data = source_data.duplicate()
	_scale_up_enemy_stat(source_data,round_number)
	source_data.life = roundi(player_controller.stat.get_final(StatController.StatType.LIFE) * 1.5)
	source_data.armor = roundi(player_controller.stat.get_final(StatController.StatType.ATTACK) * 0.8)
	return source_data


func get_enemy(round_number:int) -> EnemyData:
	var source_data = enemy_data_list.pick_random()
	source_data = source_data.duplicate()
	if round_number > 1:
		_scale_up_enemy_stat(source_data,round_number)
	return source_data
	
	
func _scale_up_enemy_stat(source:EnemyData, round_number:int):
	var min_scale_value := round_number + 1
	if min_scale_value < 0:
		min_scale_value = 1
	var max_scale_value := round_number + 3
	if max_scale_value < 0 or max_scale_value < min_scale_value:
		max_scale_value = min_scale_value
		
	
	var rand_scale_value := randi_range(min_scale_value, max_scale_value)
	if source.attack != 0:
		source.attack += roundi(rand_scale_value * Constant.ENEMY_ATK_FACTOR)
	if source.accuracy != 0:
		source.accuracy += roundi(rand_scale_value * Constant.ENEMY_ACC_FACTOR)		
	if source.speed != 0:
		source.speed += roundi(rand_scale_value * Constant.ENEMY_SPD_FACTOR)
	if source.life != 0:
		source.life += roundi(rand_scale_value * Constant.ENEMY_LIFE_FACTOR)
	if source.mana != 0:
		source.mana += roundi(rand_scale_value * Constant.ENEMY_MANA_FACTOR)						
	if source.dodge != 0:
		source.dodge += roundi(rand_scale_value * Constant.ENEMY_DODGE_FACTOR)		
	if source.armor != 0:
		source.armor += roundi(rand_scale_value * Constant.ENEMY_ARMOR_FACTOR)
	
#	# Player have more atk than enemy, increase enemy life or armor to make it more challenge	
#	if player_controller.stat.get_final(StatController.StatType.ATTACK) > source.attack:
#		source.life =  roundi(source.life * 1.5)
#	# Player have more armor than enemy, increase atk to make it more challenge	
#	if player_controller.stat.get_final(StatController.StatType.ARMOR) > source.armor:
#		source.attack = roundi(source.attack * 1.5)
#		source.speed = roundi(source.speed * 1.2)
		
		
							
