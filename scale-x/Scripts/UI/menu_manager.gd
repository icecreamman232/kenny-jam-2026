class_name MenuManager extends CanvasLayer

@export var gmtk_logo_parent:ColorRect
@export var gmtk_logo:TextureRect
@export var title_button:Button
@export var title_label:Label
@export var play_button:Button
@export var reward_label:Label
@export var bubble_text:PackedScene

const MAX_TITLE_LIFE:int = 360
var _current_life:int = 0
var _is_recovering:bool = false
var _block_input:bool = false

func _set_window_size():
	get_window().size = Vector2i(1600, 900)


func _ready():
	get_tree().paused = false
	InputManager.set_enabled(false)
	IngameDataManager.menu_reward_id = -1
	call_deferred("_set_window_size")
	_current_life = MAX_TITLE_LIFE
	title_button.pressed.connect(_on_hit_title_button)
	var shader_material := title_label.material.duplicate() as ShaderMaterial
	title_label.material = shader_material
	play_button.pressed.connect(_load_gameplay_scene)
	play_button.mouse_entered.connect(_on_mouse_enter_button)
	SaveManager.load_save_file()
	if not IngameDataManager.logo_has_shown:
		await _show_logo()
		await Helper.wait_for_seconds(1)
		IngameDataManager.logo_has_shown = true
		await _fade_logo_layout()
	else:
		gmtk_logo_parent.hide()
	InputManager.set_enabled(true)
	AudioManager.play_menu_music()
	

func _exit_tree() -> void:
	title_button.pressed.disconnect(_on_hit_title_button)
	play_button.pressed.disconnect(_load_gameplay_scene)
	play_button.mouse_entered.disconnect(_on_mouse_enter_button)
	

func _show_logo():
	var t := create_tween()
	var target_color := gmtk_logo.modulate
	target_color.a = 1
	t.tween_property(gmtk_logo, "modulate", target_color, 1.5)
	await t.finished
	

func _fade_logo_layout():
	var t := create_tween()
	var target_color := gmtk_logo_parent.modulate
	target_color.a = 0
	t.tween_property(gmtk_logo_parent, "modulate", target_color, 0.5)
	await t.finished
	gmtk_logo_parent.hide()


func _on_hit_title_button() -> void:
	if _block_input: return
	if _is_recovering: return
	var rand_damage:int = randi_range(10, 30)
	_current_life -= rand_damage
	var random_sound_id:int = randi_range(0, 1)
	AudioManager.play_sfx(SfxContainer.SfxID.SWORD_HIT_1 if random_sound_id == 0 else SfxContainer.SfxID.SWORD_HIT_2)
	var ratio:float = _current_life / float(MAX_TITLE_LIFE)
	_show_text(str(rand_damage), title_label.global_position, Color("ffe9c4"))
	(title_label.material as ShaderMaterial).set_shader_parameter("fill_amount", ratio)
	if _current_life <= 0:
		_is_recovering = true
		AudioManager.play_sfx(SfxContainer.SfxID.HEAL)
		await _recover()
		AudioManager.play_sfx(SfxContainer.SfxID.TING)
		await _bounce()
		
		var reward_id:int = randi_range(0, 2)
		IngameDataManager.menu_reward_id = reward_id
		_set_reward_text(reward_id)
		_is_recovering = false
		await _show_reward_text()
		reward_label.hide()
	
	
func _show_text(message:String, show_pos:Vector2, tint_color:Color = Color("00b610")) -> void:
	var bubble_text_instance:= bubble_text.instantiate() as BubleText
	if bubble_text_instance == null: return
	add_child(bubble_text_instance)
	show_pos.x += title_label.size.x * 0.5
	show_pos.y += title_label.size.y * 0.5
	bubble_text_instance.add_theme_color_override("default_color", tint_color)
	bubble_text_instance.add_theme_font_size_override("norma_font_size", 80)
	bubble_text_instance.global_position = show_pos + _get_random_offset()
	await Helper.wait_for_frames(1)
	bubble_text_instance.show_text(message)
	
	
func _get_random_offset() -> Vector2:
	return Vector2(randf_range(-100, 100), randf_range(-50, 50))
	

func _recover() -> void:
	var t := create_tween()
	t.tween_method(_set_fill, 0.0, 1.0, 3)
	await t.finished
	
	
func _bounce() -> void:
	var t := create_tween()
	t.set_trans(Tween.TRANS_CIRC)
	t.tween_property(title_label, "scale", Vector2.ONE * 1.1, 0.1)
	t.set_trans(Tween.TRANS_EXPO)
	t.tween_property(title_label, "scale", Vector2.ONE, 0.08)
	await t.finished
	
	
func _set_fill(progress: float):
	(title_label.material as ShaderMaterial).set_shader_parameter("fill_amount", progress)
	

func _load_gameplay_scene() -> void:
	if _block_input: return
	_block_input = true
	get_tree().change_scene_to_file("res://Scene/character_select_screen.tscn")
	
	
func _set_reward_text(reward_id:int):
	match reward_id:
		0: reward_label.text = "Reward: Gain 3 additional coins"
		1: reward_label.text = "Reward: Gain 2 additional life"
		2: reward_label.text = "Reward: Gain 1 additional attack"
	
	
func _show_reward_text():
	reward_label.show()
	await Helper.wait_for_seconds(1)
	var t := create_tween()
	var target_color := Color("ffe9c4")
	target_color.a = 0
	t.tween_property(reward_label, "self_modulate", target_color, 0.5)
	await t.finished
	
	
func _on_mouse_enter_button():
	AudioManager.play_sfx(SfxContainer.SfxID.UI_BUTTON_CLICK)
