class_name GameplayManager extends Node

@export var round_number:int = 1
@export var round_label:RichTextLabel
@export var player_controller:PlayerController
@export var enemy_controller:EnemyController
@export var loot_box_ui:LootBoxUI
@export var enemy_manager:EnemyManager
@export_group("Animations")
@export var anim_on_player:AnimatedSprite2D
@export var anim_on_enemy:AnimatedSprite2D

var is_boss_fight:bool = false
const SLASH_ANIM_NAME:String = "slash"
const MAX_ROUND:int = 25

func _ready():
	InputManager.set_enabled(false)
	EventBus.on_fight_started.connect(_on_fight_started)
	EventBus.on_player_dead.connect(_on_player_dead)
	EventBus.on_enemy_dead.connect(_on_enemy_dead)
	await Helper.wait_for_frames(5)
	enemy_controller.assign_gameplay_manager(self)
	await initialize()
	await Helper.wait_for_frames(3)
	InputManager.set_enabled(true)


func _exit_tree() -> void:
	EventBus.on_fight_started.disconnect(_on_fight_started)
	EventBus.on_player_dead.disconnect(_on_player_dead)
	EventBus.on_enemy_dead.disconnect(_on_enemy_dead)
	
	
func initialize():
	player_controller.initialize()
	_create_enemy()
	await Helper.wait_for_frames(3)
	loot_box_ui.set_round_number(round_number)
	round_label.text = "Round " + str(round_number)
	loot_box_ui.show_loot()	


func _create_boss():
	pass



func _create_enemy():
	var enemy:= enemy_manager.get_enemy(round_number)
	enemy_controller.initialize(enemy)	

func _on_player_dead():
	InputManager.set_enabled(false)
	AudioManager.play_sfx(SfxContainer.SfxID.GAME_OVER)
	print("Player dead!!!")
	print("====================================================================")

	
func restart_game():
	round_number = 1
	player_controller.reset_player()
	Helper.wait_for_frames(3)
	loot_box_ui.set_round_number(round_number)
	round_label.text = "Round " + str(round_number)
	loot_box_ui.show_loot()
	await Helper.wait_for_frames(3)
	_create_enemy()
	await Helper.wait_for_frames(3)
	InputManager.set_enabled(true)	

	
func _on_enemy_dead():
	if round_number >= MAX_ROUND:
		is_boss_fight = true
		EventBus.on_boss_appear.emit()
	round_number += 1
	loot_box_ui.set_round_number(round_number)
	if is_boss_fight:
		round_label.text = "Boss Fight"
	else:
		round_label.text = "Round " + str(round_number)
	player_controller.health.recover_full_life()
	await Helper.wait_for_frames(3)
	if is_boss_fight:
		_create_boss()
	else:
		_create_enemy()
	await Helper.wait_for_frames(3)		
	
		
	
func _on_fight_started() -> void:
	InputManager.set_enabled(false)
	# Trigger all modifiers before starting fight
	var mod_controller:ModifierController = IngameDataManager.modifier_controller
	await mod_controller.trigger_modifiers()


	var player_speed:int = player_controller.stat.get_final(StatController.StatType.SPEED)
	player_speed = roundi(player_speed / 3.0)
	if player_speed < 1: player_speed = 1
	var number_attack := randi_range(1, player_speed)
	for attempt in number_attack:
		if enemy_controller.health.current_life <= 0: break
		var rand_value:= randi_range(0, 1)
		AudioManager.play_sfx(SfxContainer.SfxID.SWORD_HIT_1 if rand_value == 0 else SfxContainer.SfxID.SWORD_HIT_2)
		anim_on_enemy.play(SLASH_ANIM_NAME)
		await player_controller.play_attack_tween()
		await player_controller.deal_damage_to_enemy(enemy_controller)
	
	if enemy_controller.health.current_life > 0:	
		var enemy_spd:int  = enemy_controller.stat.get_final(StatController.StatType.SPEED)
		enemy_spd = roundi(enemy_spd / 3.0)
		if enemy_spd < 1: enemy_spd = 1
		var enemy_number_atk:= randi_range(1, enemy_spd)
		for attemp in enemy_number_atk:
			if player_controller.health.current_life <= 0: break
			var rand_value:= randi_range(0, 1)
			AudioManager.play_sfx(SfxContainer.SfxID.MONSTER_ATK_1 if rand_value == 0 else SfxContainer.SfxID.MONSTER_ATK_2)
			anim_on_player.play(SLASH_ANIM_NAME)		
			await enemy_controller.play_attack_tween()
			await enemy_controller.deal_damage_to_player(player_controller)
			
			EventBus.on_enemy_attack.emit()
		
	await Helper.wait_for_frames(1)
	EventBus.on_fight_end.emit()
	
	loot_box_ui.show_loot()
	await Helper.wait_for_frames(1)
	InputManager.set_enabled(true)	
		


		
