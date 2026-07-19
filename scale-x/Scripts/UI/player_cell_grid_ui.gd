class_name PlayerCellGridUi extends Control

@export var grid_index:int
@export var assigned_item:ItemData
@export var item_icon:TextureRect

func assign_item(item:ItemData) -> void:
	if item == null: return
	assigned_item = item
	item_icon.texture = item.item_icon
	item_icon.self_modulate = Helper.get_color_by_rarity(item.rarity)
	var mod_controller:ModifierController = IngameDataManager.modifier_controller
	for mod in item.modifier_list:
		mod.apply(self)
		mod_controller.add_modifier(mod)
	

func unassign_item() -> void:
	if assigned_item == null: return
	var mod_controller:ModifierController = IngameDataManager.modifier_controller
	for mod in assigned_item.modifier_list:
		mod_controller.remove_modifier(mod.id)
		mod.remove()
	
	
	assigned_item = null
	item_icon.self_modulate = Color(1.0, 0.914, 0.769)
	item_icon.texture = null
	

func handle_drag(is_dragging:bool = false):
	item_icon.visible = !is_dragging
	

func play_bounce_tween():
	var tween:Tween = create_tween()
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self,"scale", Vector2.ONE * 1.2, 0.2)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self,"scale", Vector2.ONE, 0.1)
	await tween.finished
	