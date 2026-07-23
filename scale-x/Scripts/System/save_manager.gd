extends Node


var is_finished_tutorial:bool = false
const PLAYER_SAVE_FILE_PATH:String = "user://save_data.cfg"

var _current_save_file:ConfigFile

func load_save_file() -> void:
	if _current_save_file == null:
		_current_save_file = ConfigFile.new()
		var error:= _current_save_file.load(PLAYER_SAVE_FILE_PATH)
		if error != OK:
			print("Failed to load save file:", error)
			return
	
	is_finished_tutorial = _current_save_file.get_value("Settings", "is_finished_tutorial", false)
	

func save_tutorial():
	if _current_save_file == null:
		_current_save_file = ConfigFile.new()
		
	is_finished_tutorial = true	
	_current_save_file.set_value("Settings", "is_finished_tutorial", true)
	
	var error:= _current_save_file.save(PLAYER_SAVE_FILE_PATH)
	if error != OK:
		push_error("Failed to save save file:", error)