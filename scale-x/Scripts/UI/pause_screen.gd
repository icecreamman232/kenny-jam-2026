class_name PauseScreen extends Control

@export var resume_button:Button
@export var quit_button:Button

func _ready():
	resume_button.pressed.connect(_on_resume_button_pressed)
	resume_button.mouse_entered.connect(_on_mouse_enter_button)
	quit_button.pressed.connect(_on_quit_button_pressed)
	quit_button.mouse_entered.connect(_on_mouse_enter_button)
	EventBus.on_pause_game.connect(_on_pause_game)
	
	
func _exit_tree() -> void:
	resume_button.pressed.disconnect(_on_resume_button_pressed)
	resume_button.mouse_entered.disconnect(_on_mouse_enter_button)
	quit_button.pressed.disconnect(_on_quit_button_pressed)
	quit_button.mouse_entered.disconnect(_on_mouse_enter_button)
	EventBus.on_pause_game.disconnect(_on_pause_game)
	

func _on_mouse_enter_button():
	AudioManager.play_sfx(SfxContainer.SfxID.UI_BUTTON_CLICK)


func _on_pause_game(is_paused:bool):
	if is_paused: 
		show()
	else:
		get_tree().paused = false
		hide()
	
	
func _on_resume_button_pressed():
	AudioManager.play_sfx(SfxContainer.SfxID.UI_BUTTON_CLICK)
	get_tree().paused = false
	hide()
	
	
func _on_quit_button_pressed():
	AudioManager.play_sfx(SfxContainer.SfxID.UI_BUTTON_CLICK)
	AudioManager.stop_music()
	get_tree().change_scene_to_file("res://Scene/menu_scene.tscn")
