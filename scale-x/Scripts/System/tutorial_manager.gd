class_name TutorialManager extends Node

@export var overlay:Overlay
@export var tutorial_area_lootbox:Control
@export var tutorial_final:Control
@export var lootbox_confirm_button:Button
@export var final_confirm_button:Button


func _ready():
	lootbox_confirm_button.pressed.connect(_on_confirm_lootbox)
	final_confirm_button.pressed.connect(_on_finish_tutorial)

func _exit_tree() -> void:
	lootbox_confirm_button.pressed.disconnect(_on_confirm_lootbox)
	final_confirm_button.pressed.disconnect(_on_finish_tutorial)


func show_lootbox_tutorial():
	overlay.show()
	tutorial_area_lootbox.show()
	overlay.update_spotlight(tutorial_area_lootbox)
	
	
func _on_confirm_lootbox():
	tutorial_area_lootbox.hide()
	tutorial_final.show()
	overlay.update_spotlight(tutorial_final)
	
	
func _on_finish_tutorial():
	overlay.hide()
	tutorial_final.hide()
	SaveManager.save_tutorial()
	
