class_name HelpScreen extends Control

@export var close_button:Button

func _ready():
	EventBus.on_show_help_screen.connect(_on_show_screen)
	close_button.pressed.connect(_on_close_button_pressed)
	
	
func _exit_tree() -> void:
	EventBus.on_show_help_screen.disconnect(_on_show_screen)
	close_button.pressed.disconnect(_on_close_button_pressed)
	

func _on_close_button_pressed():
	AudioManager.play_sfx(SfxContainer.SfxID.UI_BUTTON_CLICK)
	hide()
	
func _on_show_screen():
	show()
