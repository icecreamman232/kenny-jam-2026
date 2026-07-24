class_name EnemyController extends EntityController

@export var stat:EnemyStatController
@export var enemy_data:EnemyData
@export var avatar:EnemyAvatar
@export var health:EnemyHealth
@export var enemy_pivot:Control
@export var hover_area:Control
var skill_list:Array[EnemySkill]
var _gameplay_manager:GameplayManager


func _ready():
	hover_area.mouse_entered.connect(_on_hover_enter)
	hover_area.mouse_exited.connect(_on_hover_exit)
	
func _exit_tree() -> void:
	hover_area.mouse_entered.disconnect(_on_hover_enter)
	hover_area.mouse_exited.disconnect(_on_hover_exit)	
	

func assign_gameplay_manager(gameplay_manager:GameplayManager):
	_gameplay_manager = gameplay_manager


func initialize(data: EnemyData):
	enemy_data = data
	stat.initialize()
	
	if enemy_data.skill_pool.size() > 0:
		var rand_skil_id:String = enemy_data.skill_pool.pick_random()
		var skill:EnemySkill= EnemySkillFactory.create_skill(rand_skil_id, self)
		if skill != null and _can_apply_skill(skill):
			skill_list.append(skill)
			skill.apply()
	
	health.initialize_health(self)
	avatar.assign(data)
	avatar.show_icon()
	EventBus.update_enemy_info.emit(stat)


func _can_apply_skill(skill:EnemySkill) -> bool:
	# Prevent player being stolen coin in early game
	if _gameplay_manager.round_number <= 3 and skill is ThiefEnemySkill: return false
	
	return true 


func trigger_skills():
	for skill in skill_list:
		skill.trigger()
		await Helper.wait_for_seconds(0.2)


func play_attack_tween():
	var tween :Tween= avatar.attack_tween()
	await tween.finished	


func on_before_dead():
	for skill in skill_list:
		skill.remove()
	skill_list.clear()	
	EventBus.on_coin_change.emit(_calculate_coin_drop())	
	
	
func deal_damage_to_player(player_controller: PlayerController):
	player_controller.health.take_damage(enemy_data.attack)


func _calculate_coin_drop() ->int:
	var total_coin:int = Constant.BASE_COIN_REWARD
	# Reward for every 3 rounds. The reward is equal to the round number.
	var round_number := _gameplay_manager.round_number
	var round_bonus:int = roundi(round_number * 0.5) if round_number % 3 == 0 else 0
	var kill_bonus:int = 0
	
	if round_number <= Constant.EARLY_GAME_1_ROUND_NUMBER:
		kill_bonus = 1
	elif round_number <= Constant.EARLY_GAME_2_ROUND_NUMBER:
		kill_bonus = 1
	elif round_number <= Constant.MID_GAME_1_ROUND_NUMBER:
		kill_bonus = 2
	elif round_number <= Constant.MID_GAME_2_ROUND_NUMBER:
		kill_bonus = 3
	elif round_number <= Constant.LATE_GAME_ROUND_NUMBER:
		kill_bonus = 4
	elif round_number > Constant.LATE_GAME_ROUND_NUMBER:
		kill_bonus = 6
		
	total_coin += round_bonus + kill_bonus
	
	return total_coin
	
	
func _on_hover_enter():
	EventBus.on_player_check_enemy_skill.emit()
	EventBus.on_hover_on_enemy.emit(self)
	avatar.show_highlight(true)
	
	
func _on_hover_exit():
	EventBus.on_mouse_exit_enemy.emit()
	avatar.show_highlight(false)
