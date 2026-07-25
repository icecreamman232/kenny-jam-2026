class_name CharacterSelectionNode extends Control

@export var is_unlock:bool = false
@export var character_data:CharacterData
@export var character_name:RichTextLabel
@export var character_avatar:TextureRect
@export var unknown_bg:Control
@export var border:Control
@export var button:Button


var _original_global_position:Vector2
var is_selected:bool = false
var _screen_ref:CharacterSelectionScreen

func _ready() -> void:
	if is_unlock:
		character_name.text = character_data.character_name
		character_avatar.texture = character_data.character_avatar
		unknown_bg.visible = false
	else:
		character_name.text = "Locked"
		character_avatar.visible = false
		unknown_bg.visible = true
	button.pressed.connect(_on_button_pressed)


func assign_screen_ref(scene_ref:CharacterSelectionScreen):
	_screen_ref = scene_ref
	_original_global_position = self.global_position
	
	
func _exit_tree() -> void:
	button.pressed.disconnect(_on_button_pressed)
	
	
func update_select():
	is_selected = !is_selected
	border.visible = is_selected
	
	if is_selected:
		await _tween_to_fire_place()
	else:
		await _tween_from_fire_place()
	

func _tween_to_fire_place():
	var jump_tween := create_tween()
	var original_pos:= self.global_position
	original_pos.y -= 32
	jump_tween.set_trans(Tween.TRANS_CIRC)
	jump_tween.tween_property(self, "global_position", original_pos, 0.15)
	original_pos.y += 32
	jump_tween.set_trans(Tween.TRANS_CIRC)
	jump_tween.tween_property(self, "global_position", original_pos, 0.1)
	await jump_tween.finished


	var fire_place_pos:= _screen_ref.fire_place.global_position
	var distance := (fire_place_pos - self.global_position).length()
	var direction:= (fire_place_pos - self.global_position).normalized()
	var target_pos:= self.global_position + direction * distance * 0.5
	var t:= create_tween()
	t.set_trans(Tween.TRANS_CIRC)
	t.tween_property(self, "global_position",  target_pos, 0.3)
	await t.finished
	
	
func _tween_from_fire_place():
	var t:= create_tween()
	t.set_trans(Tween.TRANS_EXPO)
	t.tween_property(self, "global_position", _original_global_position, 0.2)
	await t.finished			
		

	
func _on_button_pressed() -> void:
	if not is_unlock:
		_screen_ref.is_enable_input = false
		await _locked_tween() 
		_screen_ref.is_enable_input = true
		return
	
	if not _screen_ref.is_enable_input: return
	_screen_ref.is_enable_input = false
	_screen_ref.on_pressed_on_character_node(self)
	

func _locked_tween():
	var jump_tween := create_tween()
	var original_pos:= self.global_position
	original_pos.y -= 32
	jump_tween.set_trans(Tween.TRANS_CIRC)
	jump_tween.tween_property(self, "global_position", original_pos, 0.15)
	original_pos.y += 32
	jump_tween.set_trans(Tween.TRANS_CIRC)
	jump_tween.tween_property(self, "global_position", original_pos, 0.1)
	await jump_tween.finished
	
	
