class_name EnemyManager extends Node

@export var enemy_data_list:Array[EnemyData]

func get_enemy(round_number:int) -> EnemyData:
	var source_data = enemy_data_list.pick_random()
	source_data = source_data.duplicate()
	if round_number > 1:
		_scale_up_enemy_stat(source_data,round_number)
	return source_data
	
	
func _scale_up_enemy_stat(source:EnemyData, round_number:int):
	var rand_scale_value := randi_range(round_number - 2, round_number)
	if source.attack != 0:
		source.attack += rand_scale_value
	if source.speed != 0:
		source.speed += rand_scale_value
	if source.life != 0:
		source.life += rand_scale_value
	if source.mana != 0:
		source.mana += rand_scale_value						
	if source.dodge != 0:
		source.dodge += rand_scale_value		
	if source.armor != 0:
		source.armor += rand_scale_value				