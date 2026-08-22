class_name PlayerStatController extends StatController

@export var player_controller:PlayerController

func _ready():
	EventBus.on_recalculate_player_stat.connect(_recalculate_player_stat)
	
func _exit_tree() -> void:
	EventBus.on_recalculate_player_stat.disconnect(_recalculate_player_stat)	

func initialize():
	base_stats[StatType.ATTACK] = player_controller.attack
	base_stats[StatType.ACCURACY] = player_controller.accuracy
	base_stats[StatType.SPEED] = player_controller.speed
	base_stats[StatType.LIFE] = player_controller.life
	base_stats[StatType.MANA] = player_controller.mana
	base_stats[StatType.DODGE] = player_controller.dodge
	base_stats[StatType.ARMOR] = player_controller.armor
	
	final_stats[StatType.ATTACK] = base_stats[StatType.ATTACK]
	final_stats[StatType.ACCURACY] = base_stats[StatType.ACCURACY]
	final_stats[StatType.SPEED] = base_stats[StatType.SPEED]
	final_stats[StatType.LIFE] = base_stats[StatType.LIFE]
	final_stats[StatType.MANA] = base_stats[StatType.MANA]
	final_stats[StatType.DODGE] = base_stats[StatType.DODGE]
	final_stats[StatType.ARMOR] = base_stats[StatType.ARMOR]
	

func _recalculate_player_stat():
	var new_attack := base_stats[StatType.ATTACK]
	var new_accuracy := base_stats[StatType.ACCURACY]
	var new_speed := base_stats[StatType.SPEED]
	var new_life := base_stats[StatType.LIFE]
	var new_mana := base_stats[StatType.MANA]
	var new_dodge := base_stats[StatType.DODGE]
	var new_armor := base_stats[StatType.ARMOR]

	for item in player_controller.item_list:
		if item == null: continue
		new_attack += item.attack
		new_accuracy += item.accuracy
		new_speed += item.speed
		new_life += item.life
		new_mana += item.mana
		new_dodge += item.dodge
		new_armor += item.armor
	
	if player_controller._player_skill is MistCharacterSkill:
		new_dodge += new_armor
		new_armor = 0
	

	set_final(StatController.StatType.ATTACK, new_attack)
	set_final(StatController.StatType.ACCURACY, new_attack)
	set_final(StatController.StatType.SPEED, new_speed)
	set_final(StatController.StatType.LIFE, new_life)
	set_final(StatController.StatType.MANA, new_mana)
	set_final(StatController.StatType.DODGE, new_dodge)	
	set_final(StatController.StatType.ARMOR, new_armor)
	
	player_controller.health.update_life(final_stats[StatType.LIFE])
	EventBus.update_player_info.emit(self)	
	
	
func set_final(stat_type:StatType, value:int):
	super.set_final(stat_type, value)
	if player_controller._player_skill is MistCharacterSkill and stat_type == StatType.ARMOR:
		final_stats[StatType.DODGE] += value
		final_stats[stat_type] = 0			
	
	

		
	
