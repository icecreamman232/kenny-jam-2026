class_name EnemyAvatar extends Control

@export var enemy_icon:TextureRect

func assign(enemy_data: EnemyData):
	enemy_icon.texture = enemy_data.enemy_icon

