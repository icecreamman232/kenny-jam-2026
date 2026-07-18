class_name GameplayManager extends Node

@export var player_controller:PlayerController
@export var enemy_controller:EnemyController
@export var loot_box_ui:LootBoxUI
@export var enemy_manager:EnemyManager

func _ready():
	EventBus.on_fight_started.connect(_on_fight_started)
	EventBus.on_enemy_dead.connect(_on_enemy_dead)
	await initialize()

func _exit_tree() -> void:
	EventBus.on_fight_started.disconnect(_on_fight_started)
	EventBus.on_enemy_dead.disconnect(_on_enemy_dead)	
	
	
func initialize():
	player_controller.initialize()
	_create_enemy()
	await Helper.wait_for_frames(3)
	loot_box_ui.show_loot()	

func _create_enemy():
	var enemy:= enemy_manager.get_enemy()
	enemy_controller.initialize(enemy)	
	
	
func _on_fight_started():
	await player_controller.play_attack_tween()
	await player_controller.deal_damage_to_enemy(enemy_controller)
	await enemy_controller.play_attack_tween()
	await enemy_controller.deal_damage_to_player(player_controller)
	await Helper.wait_for_frames(3)
	EventBus.on_fight_end.emit()
	loot_box_ui.show_loot()	
	await Helper.wait_for_frames(3)
		
	
func _on_enemy_dead():
	_create_enemy()
