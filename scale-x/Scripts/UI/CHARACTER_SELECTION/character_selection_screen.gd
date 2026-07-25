class_name CharacterSelectionScreen extends CanvasLayer

@export var default_character_data:CharacterData
@export var fire_place:Control
@export var play_button:Button
@export_group("Skill")
@export var skill_panel:Control
@export var skill_des:RichTextLabel
@export_group("Stat")
@export var stat_panel:Control
@export var attack_label:Label
@export var accuracy_label:Label
@export var speed_label:Label
@export var life_label:Label
@export var dodge_label:Label
@export var armor_label:Label
@export_group("Character Node")
@export var character_node_list:Array[CharacterSelectionNode]
var _last_selected_node:CharacterSelectionNode

func _ready() -> void:
	skill_panel.hide()
	stat_panel.hide()
	play_button.pressed.connect(_on_go_to_gameplay)
	for node in character_node_list:
		node.assign_screen_ref(self)


func _exit_tree() -> void:
	play_button.pressed.disconnect(_on_go_to_gameplay)


func on_pressed_on_character_node(node:CharacterSelectionNode):
	AudioManager.play_sfx(SfxContainer.SfxID.UI_BUTTON_CLICK)
	node.update_select()
	if node.is_selected:
		if _last_selected_node != null and node != _last_selected_node:
			_last_selected_node.update_select()
		_last_selected_node = node
		_show_skill_desc( _last_selected_node.character_data)
		_show_stat( _last_selected_node.character_data)
		stat_panel.show()
		skill_panel.show()
	else:
		if node == _last_selected_node:
			_last_selected_node = null
			stat_panel.hide()
			skill_panel.hide()


func _show_skill_desc(character_data:CharacterData):
	var whole_desc:String = "[font_size=32][color=yellow]" + character_data.skill_display_name + "[/color][/font_size][br]" + character_data.skill_desc
	skill_des.text = whole_desc


func _show_stat(character_data:CharacterData):
	attack_label.text = str(character_data.attack)
	accuracy_label.text = str(character_data.accuracy)
	speed_label.text = str(character_data.speed)
	life_label.text = str(character_data.life)
	dodge_label.text = str(character_data.dodge)
	armor_label.text = str(character_data.armor)
	
	
func _on_go_to_gameplay():
	AudioManager.play_sfx(SfxContainer.SfxID.UI_BUTTON_CLICK)
	if _last_selected_node != null:
		IngameDataManager.selected_character_data = _last_selected_node.character_data
	else:
		IngameDataManager.selected_character_data = default_character_data
		
	AudioManager.stop_music()	
	get_tree().change_scene_to_file("res://Scene/gameplay_scene.tscn")
	
