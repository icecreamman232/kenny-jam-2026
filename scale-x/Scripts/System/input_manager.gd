extends Node

var is_enabled:bool = true

signal on_show_cheat_menu
signal on_hide_cheat_menu

func set_enabled(enabled:bool): is_enabled = enabled

var _is_showing_cheat_menu:bool = false

func _process(_delta: float) -> void:
	if not is_enabled: return
	
	if Input.is_action_just_pressed("open-cheat"):
		if _is_showing_cheat_menu:
			on_hide_cheat_menu.emit()
			_is_showing_cheat_menu = false
		else:
			on_show_cheat_menu.emit()
			_is_showing_cheat_menu = true
