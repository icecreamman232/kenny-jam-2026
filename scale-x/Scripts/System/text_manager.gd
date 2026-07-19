class_name TextManager extends Node

@export var text_parent:Control
@export var bubble_text:PackedScene

const OFFSET_X:int = 30
const OFFSET_Y:int = 30

func _ready():
	IngameDataManager.text_manager = self

func show_text(message:String, show_pos:Vector2, tint_color:Color = Color("00b610")) -> void:
	var bubble_text_instance:= bubble_text.instantiate() as BubleText
	if bubble_text_instance == null: return
	text_parent.add_child(bubble_text_instance)
	show_pos.x += 80 * 0.5
	show_pos.x -=  120 * 0.5
	bubble_text_instance.add_theme_color_override("default_color", tint_color)
	bubble_text_instance.global_position = show_pos + _get_random_offset()
	await Helper.wait_for_frames(1)
	bubble_text_instance.show_text(message)
	
	
func _get_random_offset() -> Vector2:
	return Vector2(randf_range(-OFFSET_X, OFFSET_X), randf_range(-OFFSET_Y, OFFSET_Y))



