class_name EnemyController extends EntityController

@export var stat:EnemyStatController
@export var enemy_data:EnemyData
@export var avatar:EnemyAvatar
@export var health:EnemyHealth
var _gameplay_manager:GameplayManager


func assign_gameplay_manager(gameplay_manager:GameplayManager):
	_gameplay_manager = gameplay_manager


func initialize(data: EnemyData):
	enemy_data = data
	stat.initialize()
	health.initialize_health(self)
	avatar.assign(data)
	avatar.show_icon()
	EventBus.update_enemy_info.emit(stat)


func play_attack_tween():
	var tween :Tween= avatar.attack_tween()
	await tween.finished	


func on_before_dead():
	EventBus.on_coin_change.emit(_calculate_coin_drop())	
	
	
func deal_damage_to_player(player_controller: PlayerController):
	player_controller.health.take_damage(enemy_data.attack)


func _calculate_coin_drop() ->int:
	var total_coin:int = Constant.BASE_COIN_REWARD
	# Reward for every 3 rounds. The reward is equal to the round number.
	var round_number := _gameplay_manager.round_number
	var round_bonus:int = round_number if round_number % 3 == 0 else 0
	var kill_bonus:int = 0
	
	if round_number <= Constant.EARLY_GAME_1_ROUND_NUMBER:
		kill_bonus = 1
	elif round_number <= Constant.EARLY_GAME_2_ROUND_NUMBER:
		kill_bonus = 2
	elif round_number <= Constant.MID_GAME_1_ROUND_NUMBER:
		kill_bonus = 4
	elif round_number <= Constant.MID_GAME_2_ROUND_NUMBER:
		kill_bonus = 5
	elif round_number <= Constant.LATE_GAME_ROUND_NUMBER:
		kill_bonus = 8
	elif round_number > Constant.LATE_GAME_ROUND_NUMBER:
		kill_bonus = 12
		
	total_coin += round_bonus + kill_bonus
	
	return total_coin