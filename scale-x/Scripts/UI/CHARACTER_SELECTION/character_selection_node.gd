class_name CharacterSelectionNode extends Control

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
	character_name.text = character_data.character_name
	character_avatar.texture = character_data.character_avatar
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
		

	
func _on_button_pressed():
	_screen_ref.on_pressed_on_character_node(self)

	
	
