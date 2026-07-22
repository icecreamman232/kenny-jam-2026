class_name PlayerCellGridUi extends Control

@export var grid_index:int
@export var assigned_item:ItemData
@export var item_icon:TextureRect

var is_blocked:bool = false

func _ready():
	var shader_material := item_icon.material.duplicate() as ShaderMaterial
	item_icon.material = shader_material
	

func set_block(blocked:bool):
	is_blocked = blocked
	if blocked:
		self.self_modulate = Color(0.412, 0.412, 0.412)
		item_icon.self_modulate = Color(0.412, 0.412, 0.412)
	else:
		self.self_modulate = Color.WHITE
		item_icon.self_modulate = Color.WHITE


func assign_item(item:ItemData) -> void:
	if is_blocked: return
	if item == null: return
	
	assigned_item = item
	item_icon.texture = item.item_icon
	
	if item.rarity != ItemData.ItemRarity.COMMON:
		var rarity_color = Helper.get_color_by_rarity(item.rarity)
		(item_icon.material as ShaderMaterial).set_shader_parameter("outline_color", rarity_color)
		(item_icon.material as ShaderMaterial).set_shader_parameter("outline_thickness", 1)
	
	var mod_controller:ModifierController = IngameDataManager.modifier_controller
	for mod in item.modifier_list:
		mod.apply(self)
		mod_controller.add_modifier(mod)
		await Helper.wait_for_seconds(0.05)
		
	EventBus.on_add_item_to_cell.emit(grid_index, item)


func unassign_item() -> void:
	if assigned_item == null: return
	var mod_controller:ModifierController = IngameDataManager.modifier_controller
	for mod in assigned_item.modifier_list:
		mod_controller.remove_modifier(mod.id)
		mod.remove()
	
	(item_icon.material as ShaderMaterial).set_shader_parameter("outline_thickness", 0)
	
	EventBus.on_remove_item_from_cell.emit(grid_index, assigned_item)
	
	assigned_item = null
	item_icon.self_modulate = Color(0.412, 0.412, 0.412) if is_blocked else Color(1.0, 0.914, 0.769)
	item_icon.texture = null
	

func handle_drag(is_dragging:bool = false) -> void:
	item_icon.visible = !is_dragging
	

func play_bounce_tween():
	var tween:Tween = create_tween()
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self,"scale", Vector2.ONE * 1.2, 0.2)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self,"scale", Vector2.ONE, 0.1)
	await tween.finished
	
