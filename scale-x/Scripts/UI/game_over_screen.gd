class_name GameOverScreen extends Control

@export var gameplay_manager:GameplayManager
@export var restart_button:Button
@export var quit_button:Button

var _is_showing:bool = false

func _ready():
	hide()
	EventBus.on_player_dead.connect(_on_player_dead)
	restart_button.pressed.connect(_on_restart_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	
func _exit_tree() -> void:
	EventBus.on_player_dead.disconnect(_on_player_dead)
	restart_button.pressed.disconnect(_on_restart_button_pressed)
	quit_button.pressed.disconnect(_on_quit_button_pressed)
	
	
func _on_player_dead():
	await Helper.wait_for_seconds(0.5)
	show()
	_is_showing = true

func _on_quit_button_pressed() -> void:
	if not _is_showing: return	
	
	
func _on_restart_button_pressed() -> void:
	if not _is_showing: return
	hide()
	_is_showing = false	
	gameplay_manager.restart_game()
	
