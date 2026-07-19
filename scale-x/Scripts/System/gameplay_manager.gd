class_name GameplayManager extends Node

@export var round_number:int = 1
@export var player_controller:PlayerController
@export var enemy_controller:EnemyController
@export var loot_box_ui:LootBoxUI
@export var enemy_manager:EnemyManager

func _ready():
	EventBus.on_fight_started.connect(_on_fight_started)
	EventBus.on_player_dead.connect(_on_player_dead)
	await Helper.wait_for_frames(5)
	enemy_controller.assign_gameplay_manager(self)
	await initialize()

func _exit_tree() -> void:
	EventBus.on_fight_started.disconnect(_on_fight_started)
	EventBus.on_player_dead.disconnect(_on_player_dead)
	
func initialize():
	player_controller.initialize()
	_create_enemy()
	await Helper.wait_for_frames(3)
	loot_box_ui.set_round_number(round_number)
	loot_box_ui.show_loot()	

func _create_enemy():
	var enemy:= enemy_manager.get_enemy(round_number)
	enemy_controller.initialize(enemy)	

func _on_player_dead():
	print("Player dead!!!")
	EventBus.on_coin_change.emit(Constant.STARTING_COINS)
	round_number = 1
	player_controller.reset_player()
	Helper.wait_for_frames(3)
	loot_box_ui.set_round_number(round_number)
	loot_box_ui.show_loot()
	await Helper.wait_for_frames(3)
	_create_enemy()
	
		
	
func _on_fight_started() -> void:
	# Trigger all modifiers before starting fight
	var mod_controller:ModifierController = IngameDataManager.modifier_controller
	await mod_controller.trigger_modifiers()


	var player_speed:int = player_controller.stat.get_final(StatController.StatType.SPEED)
	player_speed = roundi(player_speed / 3.0)
	var number_attack := randi_range(1, player_speed)
	for attempt in number_attack:
		await player_controller.play_attack_tween()
		await player_controller.deal_damage_to_enemy(enemy_controller)
	
	if enemy_controller.health.current_life > 0:	
		var enemy_spd:int  = enemy_controller.stat.get_final(StatController.StatType.SPEED)
		enemy_spd = roundi(enemy_spd / 3.0)
		var enemy_number_atk:= randi_range(1, enemy_spd)
		for attemp in enemy_number_atk:
			await enemy_controller.play_attack_tween()
			await enemy_controller.deal_damage_to_player(player_controller)
		
	await Helper.wait_for_frames(3)
	EventBus.on_fight_end.emit()
	
	if player_controller.health.current_life < 0: return
	
	if player_controller.health.current_life > 0 and enemy_controller.health.current_life <= 0:
		round_number += 1
		loot_box_ui.set_round_number(round_number)
		player_controller.health.recover_full_life()
		await Helper.wait_for_frames(3)
		_create_enemy()
		await Helper.wait_for_frames(3)
		
	loot_box_ui.show_loot()
	await Helper.wait_for_seconds(1)	
		


		

