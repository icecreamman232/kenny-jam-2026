class_name PlayerCellGridUi extends Control

@export var grid_index:int
@export var assigned_item:ItemData
@export var item_icon:TextureRect
@export var progress_bar:ProgressBar

var _fill_style:StyleBoxFlat
const FULL_DURABILITY_COLOR:Color = Color("4ade805a")
const HALF_DURABILITY_COLOR:Color = Color("fbbf245a")
const FEW_DURABILITY_COLOR:Color = Color("e6482e5a")

var is_blocked:bool = false

func _ready():
	EventBus.on_apply_item.connect(_on_apply_item)
	var shader_material := item_icon.material.duplicate() as ShaderMaterial
	item_icon.material = shader_material
	progress_bar.value = 0
	var fill_style := progress_bar.get_theme_stylebox("fill") as StyleBoxFlat
	_fill_style = fill_style.duplicate()
	
	
func _exit_tree() -> void:
	EventBus.on_apply_item.disconnect(_on_apply_item)	


func _on_apply_item(index:int, item:ItemData) -> void:
	if self.grid_index != index: return
	await assign_item(item)


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
	
	progress_bar.max_value = assigned_item.max_durability
	progress_bar.value = assigned_item.durability
	_set_color_for_current_durability()
		
	EventBus.on_add_item_to_cell.emit(grid_index, item)


func update_item_durability() -> void:
	if assigned_item == null: return
	assigned_item.durability -= 1
	progress_bar.value = assigned_item.durability
	_set_color_for_current_durability()	
	if assigned_item.durability <= 0:
		unassign_item()
	

func unassign_item() -> void:
	if assigned_item == null: return
	var mod_controller:ModifierController = IngameDataManager.modifier_controller
	for mod in assigned_item.modifier_list:
		mod_controller.remove_modifier(mod.id)
		mod.remove()
	
	(item_icon.material as ShaderMaterial).set_shader_parameter("outline_thickness", 0)
	
	EventBus.on_remove_item_from_cell.emit(grid_index, assigned_item)
	
	progress_bar.value = 0
	_set_color_for_current_durability()
	
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
	
	
func _set_color_for_current_durability() -> void:
	var few_threshold := ceili(assigned_item.max_durability * 0.25)
	var half_threshold := ceili(assigned_item.max_durability * 0.5)
	
	var target_color: Color
	if assigned_item.durability <= few_threshold:
		target_color = FEW_DURABILITY_COLOR
	elif assigned_item.durability <= half_threshold:
		target_color = HALF_DURABILITY_COLOR
	else:
		target_color = FULL_DURABILITY_COLOR
	
	if _fill_style:
		_fill_style.bg_color = target_color
		progress_bar.add_theme_stylebox_override("fill", _fill_style)
	
