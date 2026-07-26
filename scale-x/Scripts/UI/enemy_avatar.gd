class_name EnemyAvatar extends Control

@export var enemy_icon:TextureRect
@export var hex_icon:Texture2D
var _normal_icon:Texture2D

func _ready():	
	var shader_material := enemy_icon.material.duplicate() as ShaderMaterial
	enemy_icon.material = shader_material

func assign(enemy_data: EnemyData):
	_normal_icon = enemy_data.enemy_icon
	enemy_icon.texture = enemy_data.enemy_icon


func change_visual_to_be_hex():
	enemy_icon.texture = hex_icon
	
	
func change_visual_to_be_normal():
	enemy_icon.texture = _normal_icon
	

func attack_tween() ->Tween:
	var tween:= create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(enemy_icon, "position", enemy_icon.position + Vector2(-1, 0) * 80, 0.2)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(enemy_icon, "position", enemy_icon.position, 0.1)
	return tween
	
	
func disappear_icon_tween() ->Tween:
	var tween:= create_tween()
	var current_modulate:= enemy_icon.self_modulate
	var target_modulate:= current_modulate
	target_modulate.a = 0
	tween.tween_property(enemy_icon, "self_modulate", target_modulate, 0.3)
	return tween
	
	
func show_icon():
	enemy_icon.self_modulate = Color.WHITE
	
	
func show_highlight(is_show:bool):
	(enemy_icon.material as ShaderMaterial).set_shader_parameter("outline_thickness", 1 if is_show else 0)
		
