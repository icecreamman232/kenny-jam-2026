class_name PlayerAvatar extends Control

@export var player_icon:TextureRect

func _attack_tween() ->Tween:
	var tween:= create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(player_icon, "position", position + Vector2.RIGHT * 0.3, 0.2)
	return tween
