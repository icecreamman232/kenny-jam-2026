class_name VictoryScreen extends Control

@export var restart_button:Button
@export var quit_button:Button

func _ready():
	hide()
	EventBus.on_victory.connect(_on_show_screen)
	restart_button.pressed.connect(_on_restart_button_pressed)
	restart_button.mouse_entered.connect(_on_mouse_enter_button)
	quit_button.pressed.connect(_on_quit_button_pressed)
	quit_button.mouse_entered.connect(_on_mouse_enter_button)


func _exit_tree() -> void:
	EventBus.on_victory.disconnect(_on_show_screen)
	restart_button.pressed.disconnect(_on_restart_button_pressed)
	restart_button.mouse_entered.disconnect(_on_mouse_enter_button)
	quit_button.pressed.disconnect(_on_quit_button_pressed)
	quit_button.mouse_entered.disconnect(_on_mouse_enter_button)


func _on_show_screen():
	AudioManager.stop_music()
	show()
	AudioManager.play_sfx(SfxContainer.SfxID.VICTORY)
	
	
func _on_mouse_enter_button():
	AudioManager.play_sfx(SfxContainer.SfxID.UI_BUTTON_CLICK)	
	
	
func _on_quit_button_pressed() -> void:
	AudioManager.play_sfx(SfxContainer.SfxID.UI_BUTTON_CLICK)
	AudioManager.stop_music()
	get_tree().change_scene_to_file("res://Scene/menu_scene.tscn")	

	
func _on_restart_button_pressed() -> void:
	AudioManager.play_sfx(SfxContainer.SfxID.UI_BUTTON_CLICK)
	hide()
	(IngameDataManager.gameplay_manager as GameplayManager).restart_game()	