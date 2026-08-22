class_name CheatCharacterUnlockPanel extends Control

@export var unlock_button:Button
@export var character_unlock_option_button:OptionButton

func _ready():
	unlock_button.pressed.connect(_on_unlock_button_pressed)
	character_unlock_option_button.clear()
	for character_id in CharacterData.CharacterID.keys():
		character_unlock_option_button.add_item(str(character_id))

func _exit_tree() -> void:
	unlock_button.pressed.disconnect(_on_unlock_button_pressed)
	

func _hide_panel():
	hide()
	IngameDataManager.cheat_manager.has_popup_open = false
	
	
func _on_unlock_button_pressed():
	var selected_index := character_unlock_option_button.selected
	var selected_id:CharacterData.CharacterID = CharacterData.CharacterID.values()[selected_index]
	SaveManager.unlock_character(selected_id)
	_hide_panel()
