class_name TextManager extends Node

@export var text_parent:Control
@export var bubble_text:PackedScene

func _ready():
	IngameDataManager.text_manager = self

func show_text(message:String, show_pos:Vector2) -> void:
	var bubble_text_instance:= bubble_text.instantiate() as BubleText
	if bubble_text_instance == null: return
	text_parent.add_child(bubble_text_instance)
	show_pos.x += 80 * 0.5
	show_pos.x -=  120 * 0.5
	bubble_text_instance.global_position = show_pos
	await Helper.wait_for_frames(1)
	bubble_text_instance.show_text(message)



