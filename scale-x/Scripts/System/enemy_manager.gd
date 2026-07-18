class_name EnemyManager extends Node

@export var enemy_data_list:Array[EnemyData]

func get_enemy() -> EnemyData:
	return enemy_data_list.pick_random()