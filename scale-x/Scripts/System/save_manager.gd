extends Node


var is_finished_tutorial:bool = false
const PLAYER_SAVE_FILE_PATH:String = "user://save_data.cfg"

var character_unlock_progress:Dictionary[CharacterData.CharacterID, bool] ={
	CharacterData.CharacterID.Knight: true,
	CharacterData.CharacterID.King: false,
	CharacterData.CharacterID.Rogue: false,
	CharacterData.CharacterID.Executioner: false,
}

var _current_save_file:ConfigFile

func load_save_file() -> void:
	if _current_save_file == null:
		_current_save_file = ConfigFile.new()
		var error:= _current_save_file.load(PLAYER_SAVE_FILE_PATH)
		if error != OK:
			print("Failed to load save file:", error)
			return
	
	is_finished_tutorial = _current_save_file.get_value("Settings", "is_finished_tutorial", false)
	character_unlock_progress[CharacterData.CharacterID.King] = _current_save_file.get_value("Unlock", "unlock_king", false)
	character_unlock_progress[CharacterData.CharacterID.Rogue] = _current_save_file.get_value("Unlock", "unlock_rogue", false)
	character_unlock_progress[CharacterData.CharacterID.Executioner] = _current_save_file.get_value("Unlock", "unlock_executioner", false)
	character_unlock_progress[CharacterData.CharacterID.Farmer] = _current_save_file.get_value("Unlock", "unlock_farmer", false)
	character_unlock_progress[CharacterData.CharacterID.Devil] = _current_save_file.get_value("Unlock", "unlock_devil", false)
	character_unlock_progress[CharacterData.CharacterID.Ghost] = _current_save_file.get_value("Unlock", "unlock_ghost", false)
	character_unlock_progress[CharacterData.CharacterID.Psycho_Kid] = _current_save_file.get_value("Unlock", "unlock_psycho_kid", false)


func save_tutorial():
	if _current_save_file == null:
		_current_save_file = ConfigFile.new()
		
	is_finished_tutorial = true	
	_current_save_file.set_value("Settings", "is_finished_tutorial", true)
	
	var error:= _current_save_file.save(PLAYER_SAVE_FILE_PATH)
	if error != OK:
		push_error("Failed to save save file:", error)
		
		
func unlock_character(character_id:CharacterData.CharacterID):
	if _current_save_file == null:
		_current_save_file = ConfigFile.new()
	var unlock_key:= _get_character_unlock_keyname(character_id)	
	_current_save_file.set_value("Unlock", unlock_key, character_unlock_progress[character_id])
	var error:= _current_save_file.save(PLAYER_SAVE_FILE_PATH)
	if error != OK:
		push_error("Failed to save save file:", error)	
		
		
func _get_character_unlock_keyname(character_id:CharacterData.CharacterID) -> String:
	match character_id:
		CharacterData.CharacterID.Knight: return "unlock_knight"
		CharacterData.CharacterID.King: return "unlock_king"
		CharacterData.CharacterID.Rogue: return "unlock_rogue"
		CharacterData.CharacterID.Executioner: return "unlock_executioner"
		CharacterData.CharacterID.Farmer: return "unlock_farmer"
		CharacterData.CharacterID.Devil: return "unlock_devil"
		CharacterData.CharacterID.Ghost: return "unlock_ghost"
		CharacterData.CharacterID.Psycho_Kid: return "unlock_psycho_kid"
		_: return ""
	