class_name BlacksmithShopSlot extends Control

@export var shop_ref:BlacksmithShop
@export var item_icon:TextureRect
@export var background:TextureRect
@export var durability_progress:ProgressBar
@export var button:Button

var assigned_cell:PlayerCellGridUi

func _ready():
	button.pressed.connect(_on_button_pressed)
	
	
func _exit_tree() -> void:
	button.pressed.disconnect(_on_button_pressed)


func assign_slot(cell:PlayerCellGridUi):
	assigned_cell = cell
	if assigned_cell.assigned_item != null:
		item_icon.texture = assigned_cell.item_icon.texture
		durability_progress.max_value = assigned_cell.assigned_item.max_durability
		durability_progress.value = assigned_cell.assigned_item.durability
	else:
		item_icon.texture = null
		durability_progress.max_value = 1
		durability_progress.value = 0
		
		
func reset_slot():
	assigned_cell = null
	item_icon.texture = null
	durability_progress.max_value = 1
	durability_progress.value = 0

		
func update_slot_visual():
	durability_progress.value = assigned_cell.assigned_item.durability


func play_bounce_tween():
	var tween:Tween = create_tween()
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self,"scale", Vector2.ONE * 1.2, 0.2)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self,"scale", Vector2.ONE, 0.1)
	await tween.finished

		
func _on_button_pressed() -> void:
	if assigned_cell == null: return
	shop_ref.request_to_fix_slot(assigned_cell, self)
		
		
	
