class_name LootBoxUI extends Control

@export var coin_hud:CoinHud
@export var loot_manager:LootManager
@export var gameplay_manager:GameplayManager
@export var player_grid_ui:PlayerGridUi
@export var reroll_price_label:RichTextLabel
@export var reroll_button:Button
@export var context_cursor:TextureRect
@export var loot_box_cell_ui:Array[LootBoxCellUi]

var _last_round_number:int = 0
var _inspecting_cell:LootBoxCellUi
var _dragging:bool = false
var _drag_offset:Vector2 = Vector2.ZERO
const CELL_SIZE:float = 80

func _ready():
	reroll_button.pressed.connect(_on_reroll_button_pressed)
	for cell in loot_box_cell_ui:
		cell.mouse_entered.connect(_on_mouse_entered_cell.bind(cell))
		cell.mouse_exited.connect(_on_mouse_exited_cell.bind(cell))


func _exit_tree() ->void:
	reroll_button.pressed.disconnect(_on_reroll_button_pressed)
	for cell in loot_box_cell_ui:
		cell.mouse_entered.disconnect(_on_mouse_entered_cell.bind(cell))
		cell.mouse_exited.disconnect(_on_mouse_exited_cell.bind(cell))


func _input(event:InputEvent) -> void:
	if not InputManager.is_enabled: return	
	if not visible: return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_dragging = event.pressed
			if _dragging:
				if _inspecting_cell != null and _inspecting_cell.assigned_item != null:
					AudioManager.play_sfx(SfxContainer.SfxID.UI_BUTTON_CLICK)
					context_cursor.texture = _inspecting_cell.assigned_item.item_icon
					context_cursor.modulate = _inspecting_cell.assigned_item_icon.self_modulate
					_drag_offset = _inspecting_cell.global_position - get_global_mouse_position()
					context_cursor.global_position = _get_dragged_position()
					_inspecting_cell.handle_drag(_dragging)
					context_cursor.show()
					get_viewport().set_input_as_handled()
			else:
				if _inspecting_cell != null and _inspecting_cell.assigned_item != null:
					var result := player_grid_ui.request_drop_item(_inspecting_cell.assigned_item, coin_hud)
					if result:
						context_cursor.hide()
						_inspecting_cell.unassign_item()
						_inspecting_cell.handle_drag(_dragging)
						_inspecting_cell.self_modulate = Color(1.0, 0.914, 0.769)
						_inspecting_cell = null
					else:
						context_cursor.hide()
						_inspecting_cell.handle_drag(_dragging)
						_inspecting_cell.self_modulate = Color(1.0, 0.914, 0.769)
						_inspecting_cell = null
					get_viewport().set_input_as_handled()	
					
		
	elif event is InputEventMouseMotion and _dragging:
		if _inspecting_cell != null:
			context_cursor.global_position = _get_dragged_position()

func set_round_number(round_number:int):
	_last_round_number = round_number


func show_loot():
	var loot_items:= loot_manager.get_items(_last_round_number)
	for idx in range(loot_items.size()):
		loot_box_cell_ui[idx].assign_item(loot_items[idx])


func _get_dragged_position() -> Vector2:
	return get_global_mouse_position() + _drag_offset
		

func _on_reroll_button_pressed() -> void:
	if not InputManager.is_enabled: return
	AudioManager.play_sfx(SfxContainer.SfxID.UI_BUTTON_CLICK)
	var reroll_price:int = 0
	var round_number:= gameplay_manager.round_number
	if round_number <= Constant.EARLY_GAME_1_ROUND_NUMBER:
		reroll_price = 1
	elif round_number <= Constant.EARLY_GAME_2_ROUND_NUMBER:
		reroll_price = 2
	elif round_number <= Constant.MID_GAME_1_ROUND_NUMBER:
		reroll_price = 3
	elif round_number <= Constant.MID_GAME_2_ROUND_NUMBER:
		reroll_price = 5
	elif round_number <= Constant.LATE_GAME_ROUND_NUMBER:
		reroll_price = 8
	elif round_number > Constant.LATE_GAME_ROUND_NUMBER:
		reroll_price = 10	
	
	if coin_hud.current_coin < reroll_price: return
		
	show_loot()
	reroll_price_label.text = "[img=24]uid://de3k1fl4j5llo[/img] " + str(reroll_price).pad_decimals(0)	
	EventBus.on_coin_change.emit(-reroll_price)
	await Helper.wait_for_frames(3)	

		
func _on_mouse_entered_cell(cell:LootBoxCellUi) -> void:
	if not InputManager.is_enabled: return
	AudioManager.play_sfx(SfxContainer.SfxID.UI_BUTTON_CLICK)	
	_inspecting_cell = cell
	_inspecting_cell.self_modulate = Color(0.957, 0.706, 0.106)
	EventBus.on_hover_on_item.emit(_inspecting_cell.assigned_item)
	
	
func _on_mouse_exited_cell(cell:LootBoxCellUi) -> void:
	if _inspecting_cell != cell: return
	if _dragging: return
	_inspecting_cell.self_modulate = Color(1.0, 0.914, 0.769)
	EventBus.on_hover_on_item.emit(null)
	_inspecting_cell = null
