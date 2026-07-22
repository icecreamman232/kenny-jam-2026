class_name EnemyManager extends Node


@export var enemy_data_list:Array[EnemyData]

func get_enemy(round_number:int) -> EnemyData:
	var source_data = enemy_data_list.pick_random()
	source_data = source_data.duplicate()
	if round_number > 1:
		_scale_up_enemy_stat(source_data,round_number)
	return source_data
	
	
func _scale_up_enemy_stat(source:EnemyData, round_number:int):
	var min_scale_value := round_number + 2
	if min_scale_value < 0:
		min_scale_value = 1
	var max_scale_value := round_number + 4
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