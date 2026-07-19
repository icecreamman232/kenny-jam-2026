class_name PlayerInfoUi extends Control

@export var atk_label:Label
@export var acc_label:Label
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
	atk_label.text = str(stat.get_final(StatController.StatType.ATTACK))
	acc_label.text = str(stat.get_final(StatController.StatType.ACCURACY))
	speed_label.text = str(stat.get_final(StatController.StatType.SPEED))
	life_label.text = str(stat.get_final(StatController.StatType.LIFE))
	mana_label.text = str(stat.get_final(StatController.StatType.MANA))
	dodge_label.text = str(stat.get_final(StatController.StatType.DODGE))
	armor_label.text = str(stat.get_final(StatController.StatType.ARMOR))
