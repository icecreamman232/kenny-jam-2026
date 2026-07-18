class_name EnemyStatController extends StatController

@export var enemy_controller:EnemyController

func initialize():
	base_stats[StatType.ATTACK] = enemy_controller.enemy_data.attack
	base_stats[StatType.SPEED] = enemy_controller.enemy_data.speed
	base_stats[StatType.LIFE] = enemy_controller.enemy_data.life
	base_stats[StatType.MANA] = enemy_controller.enemy_data.mana
	base_stats[StatType.DODGE] = enemy_controller.enemy_data.dodge
	base_stats[StatType.ARMOR] = enemy_controller.enemy_data.armor
	
	final_stats[StatType.ATTACK] = base_stats[StatType.ATTACK]
	final_stats[StatType.SPEED] = base_stats[StatType.SPEED]
	final_stats[StatType.LIFE] = base_stats[StatType.LIFE]
	final_stats[StatType.MANA] = base_stats[StatType.MANA]
	final_stats[StatType.DODGE] = base_stats[StatType.DODGE]
	final_stats[StatType.ARMOR] = base_stats[StatType.ARMOR]
