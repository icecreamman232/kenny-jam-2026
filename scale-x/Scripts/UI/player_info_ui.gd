class_name PlayerInfoUi extends Control

@export var atk_label:Label
@export var speed_label:Label
@export var life_label:Label
@export var mana_label:Label
@export var dodge_label:Label
@export var armor_label:Label


func _ready():
	EventBus.update_player_info.connect(_update_player_stat)
	
	
func _exit_tree() -> void:
	EventBus.update_player_info.disconnect(_update_player_stat)


func _update_player_stat(stat:PlayerStatController):
	atk_label.text = str(stat.get_base(StatController.StatType.ATTACK) + stat.get_final(StatController.StatType.ATTACK))
	speed_label.text = str(stat.get_base(StatController.StatType.SPEED) + stat.get_final(StatController.StatType.SPEED))
	life_label.text = str(stat.get_base(StatController.StatType.LIFE) + stat.get_final(StatController.StatType.LIFE))
	mana_label.text = str(stat.get_base(StatController.StatType.MANA) + stat.get_final(StatController.StatType.MANA))
	dodge_label.text = str(stat.get_base(StatController.StatType.DODGE) + stat.get_final(StatController.StatType.DODGE))
	armor_label.text = str(stat.get_base(StatController.StatType.ARMOR) + stat.get_final(StatController.StatType.ARMOR))

