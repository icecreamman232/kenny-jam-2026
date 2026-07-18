class_name PlayerAvatar extends Control

@export var player_icon:TextureRect


func attack_tween() ->Tween:
	var tween:= create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(player_icon, "position", player_icon.position + Vector2(1, 0) * 80, 0.2)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(player_icon, "position", player_icon.position, 0.1)
	return tween
