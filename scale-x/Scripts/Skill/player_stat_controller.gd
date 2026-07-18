class_name PlayerStatController extends StatController

@export var player_controller:PlayerController

func initialize():
	base_stats[StatType.ATTACK] = player_controller.attack
	base_stats[StatType.SPEED] = player_controller.speed
	base_stats[StatType.LIFE] = player_controller.life
	base_stats[StatType.MANA] = player_controller.mana
	base_stats[StatType.DODGE] = player_controller.dodge
	base_stats[StatType.ARMOR] = player_controller.armor
	
	base_stats[StatType.ATTACK] = final_stats[StatType.ATTACK]
	base_stats[StatType.SPEED] = final_stats[StatType.SPEED]
	base_stats[StatType.LIFE] = final_stats[StatType.LIFE]
	base_stats[StatType.MANA] = final_stats[StatType.MANA]
	base_stats[StatType.DODGE] = final_stats[StatType.DODGE]
	base_stats[StatType.ARMOR] = final_stats[StatType.ARMOR]
		
	
