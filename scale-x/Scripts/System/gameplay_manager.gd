class_name GameplayManager extends Node

@export var player_controller:PlayerController
@export var enemy_controller:EnemyController
@export var loot_box_ui:LootBoxUI
@export var enemy_manager:EnemyManager

func _ready():
	player_controller.initialize()
	var enemy:= enemy_manager.get_enemy()
	enemy_controller.initialize(enemy)
	await Helper.wait_for_frames(3)
	loot_box_ui.show_loot()
