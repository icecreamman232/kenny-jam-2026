class_name CheatManager extends Control

@export var is_immortal_check_button:CheckButton
@export var always_execute_check_button:CheckButton
@export var load_chicken_boss_button:Button

var is_immortal:bool = false
var is_always_execute:bool = false

func _ready():
	InputManager.on_show_cheat_menu.connect(_show_menu)
	InputManager.on_hide_cheat_menu.connect(_hide_menu)
	load_chicken_boss_button.pressed.connect(_load_chicken_boss)
	IngameDataManager.cheat_manager = self
	is_immortal_check_button.toggled.connect(_is_immortal_check_button_toggled)
	always_execute_check_button.toggled.connect(_always_execute_check_button_toggled)
	
	
func _exit_tree() -> void:
	InputManager.on_show_cheat_menu.disconnect(_show_menu)
	InputManager.on_hide_cheat_menu.disconnect(_hide_menu)
	load_chicken_boss_button.pressed.disconnect(_load_chicken_boss)
	is_immortal_check_button.toggled.disconnect(_is_immortal_check_button_toggled)
	always_execute_check_button.toggled.disconnect(_always_execute_check_button_toggled)


func _show_menu() -> void:
	if OS.has_feature("public"): return
	show()
	
	
func _hide_menu():
	hide()
		
	
func _is_immortal_check_button_toggled(is_toggled:bool):
	is_immortal = is_toggled
	

func _always_execute_check_button_toggled(is_toggled:bool):
	is_always_execute = is_toggled
	
	
func _load_chicken_boss():
	var gameplay_manager := IngameDataManager.gameplay_manager as GameplayManager
	gameplay_manager.round_number = GameplayManager.MAX_ROUND
	gameplay_manager.enemy_controller.health.take_damage(1000000000)
	
