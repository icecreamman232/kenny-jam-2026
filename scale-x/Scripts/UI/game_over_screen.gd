class_name GameOverScreen extends Control

@export var best_score_label:Label
@export var restart_button:Button
@export var quit_button:Button

var _is_showing:bool = false

func _ready():
	hide()
	EventBus.on_player_dead.connect(_on_player_dead)
	restart_button.pressed.connect(_on_restart_button_pressed)
	restart_button.mouse_entered.connect(_on_mouse_enter_button)
	quit_button.pressed.connect(_on_quit_button_pressed)
	quit_button.mouse_entered.connect(_on_mouse_enter_button)
	
func _exit_tree() -> void:
	EventBus.on_player_dead.disconnect(_on_player_dead)
	restart_button.pressed.disconnect(_on_restart_button_pressed)
	restart_button.mouse_entered.disconnect(_on_mouse_enter_button)
	quit_button.pressed.disconnect(_on_quit_button_pressed)
	quit_button.mouse_entered.disconnect(_on_mouse_enter_button)
	
	
func _on_player_dead():
	await Helper.wait_for_seconds(0.5)
	AudioManager.play_sfx(SfxContainer.SfxID.GAME_OVER)
	best_score_label.text = "Best Round: " + str(26 - IngameDataManager.gameplay_manager.round_number)
	show()
	_is_showing = true


func _on_mouse_enter_button():
	AudioManager.play_sfx(SfxContainer.SfxID.UI_BUTTON_CLICK)


func _on_quit_button_pressed() -> void:
	if not _is_showing: return
	AudioManager.play_sfx(SfxContainer.SfxID.UI_BUTTON_CLICK)
	AudioManager.stop_music()	
	get_tree().change_scene_to_file("res://Scene/menu_scene.tscn")
	
	
func _on_restart_button_pressed() -> void:
	if not _is_showing: return
	AudioManager.play_sfx(SfxContainer.SfxID.UI_BUTTON_CLICK)
	hide()
	_is_showing = false	
	IngameDataManager.gameplay_manager.restart_game()
	
