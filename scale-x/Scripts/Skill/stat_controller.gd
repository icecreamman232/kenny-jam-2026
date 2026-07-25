class_name StatController extends Node

enum StatType
{
	ATTACK,
	ACCURACY,
	SPEED,
	LIFE,
	MANA,
	DODGE,
	ARMOR
}

@export var base_stats:Dictionary[StatType, int]
@export var final_stats:Dictionary[StatType, int]

func initialize(): pass


func get_base(stat:StatType) -> int: return base_stats[stat]

func get_final(stat:StatType) -> int: return final_stats[stat]

func set_base(stat:StatType, value:int): base_stats[stat] = value

func set_final(stat:StatType, value:int): final_stats[stat] = value


static func get_stat_name(stat:StatType) -> String:
	match stat:
		StatType.ATTACK: return "Atk"
		StatType.ACCURACY: return "Acc"
		StatType.SPEED: return "Spd"
		StatType.LIFE: return "Life"
		StatType.DODGE: return "Dodge"
		StatType.ARMOR: return "Armor"
		_: return ""
