class_name PlayerGridUi extends Control

@export var context_cursor:TextureRect
@export var fight_button:Button
@export var cell_grid:Array[PlayerCellGridUi]
var _hovered_cell:PlayerCellGridUi

var _is_fighting:bool = false
var _dragging_slot_index:int = -1
var _dragging:bool = false
var _drag_offset:Vector2 = Vector2.ZERO

func _ready():
	IngameDataManager.player_grid = self
	EventBus.on_fight_end.connect(_on_fight_end)
	EventBus.on_player_dead.connect(_on_player_dead)
	fight_button.pressed.connect(_on_fight_button_pressed)
	for cell in cell_grid:
		cell.mouse_entered.connect(_on_mouse_entered_cell.bind(cell))
		cell.mouse_exited.connect(_on_mouse_exited_cell.bind(cell))
		
		
func _exit_tree() -> void:
	EventBus.on_fight_end.disconnect(_on_fight_end)
	EventBus.on_player_dead.disconnect(_on_player_dead)
	fight_button.pressed.disconnect(_on_fight_button_pressed)
	for cell in cell_grid:
		cell.mouse_entered.disconnect(_on_mouse_entered_cell.bind(cell))
		cell.mouse_exited.disconnect(_on_mouse_exited_cell.bind(cell))


func _input(event:InputEvent) -> void:
	if not visible: return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_dragging = event.pressed
			if _dragging:
				if _dragging_slot_index == -1:
					if _hovered_cell != null and _hovered_cell.assigned_item != null:
						_dragging_slot_index = _hovered_cell.grid_index
						context_cursor.texture = _hovered_cell.assigned_item.item_icon
						context_cursor.modulate = _hovered_cell.item_icon.self_modulate
						_drag_offset = _hovered_cell.global_position - get_global_mouse_position()
						_hovered_cell.handle_drag(_dragging)
						context_cursor.show()
						get_viewport().set_input_as_handled()
			else:
				if _hovered_cell != null:
					var _inspecting_cell := cell_grid[_dragging_slot_index]
					var result := request_move_item(_inspecting_cell.grid_index, _hovered_cell.grid_index)
					if result:
						context_cursor.hide()
						_inspecting_cell.handle_drag(_dragging)
					else:
						context_cursor.hide()
						_inspecting_cell.handle_drag(_dragging)
					_dragging_slot_index = -1	
					get_viewport().set_input_as_handled()	
					
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			_handle_right_click(event)
	elif event is InputEventMouseMotion and _dragging:
		if _dragging_slot_index != -1:
			context_cursor.global_position = _get_dragged_position()		


func _get_dragged_position() -> Vector2:
	return get_global_mouse_position() + _drag_offset

func _handle_left_click(event:InputEventMouseButton) -> void:
	if _hovered_cell != null and _hovered_cell.assigned_item != null:
		context_cursor.texture = _hovered_cell.assigned_item.item_icon
		_hovered_cell.handle_drag()


func _handle_right_click(event:InputEventMouseButton) -> void:
	if _hovered_cell != null and _hovered_cell.assigned_item != null:
		var item_to_be_removed := _hovered_cell.assigned_item
		var price_for_item := ItemData.get_price_for_item(item_to_be_removed)
		var sell_price := price_for_item * 0.5
		if sell_price <= 1: sell_price = 1
		EventBus.on_coin_change.emit(sell_price)
		EventBus.on_remove_item.emit(_hovered_cell.grid_index)
		await Helper.wait_for_frames(1)
		_hovered_cell.unassign_item()
		

func request_move_item(from_index:int, to_index:int) -> bool:
	var item_from := cell_grid[from_index].assigned_item
	var item_to := cell_grid[to_index].assigned_item
	cell_grid[from_index].unassign_item()
	cell_grid[to_index].unassign_item()
	# If hovering slot has item, we swap this item with dragging item
	if item_to != null:
		cell_grid[from_index].assign_item(item_to)
	cell_grid[to_index].assign_item(item_from)
	EventBus.on_move_item.emit(from_index, to_index)
	return true


func request_drop_item(item:ItemData, coin_hud: CoinHud) ->bool:
	if _hovered_cell == null: return false
	
	var price_for_item := ItemData.get_price_for_item(item)
	if coin_hud.current_coin < price_for_item: return false
	
	EventBus.on_coin_change.emit(-price_for_item)
	_hovered_cell.assign_item(item)
	EventBus.on_add_item.emit(_hovered_cell.grid_index, item)
	return true


func _on_fight_button_pressed() -> void:
	if _is_fighting: return
	EventBus.on_fight_started.emit()
	_is_fighting = true
	
	
func _on_fight_end():
	_is_fighting = false


func _on_player_dead():
	for cell in cell_grid:
		cell.handle_drag(false)
		cell.unassign_item()
	
	
func _on_mouse_entered_cell(cell:PlayerCellGridUi):
	_hovered_cell = cell
	_hovered_cell.self_modulate = Color(0.957, 0.706, 0.106)
	EventBus.on_hover_on_item.emit(_hovered_cell.assigned_item)

	
func _on_mouse_exited_cell(cell:PlayerCellGridUi) -> void:
	if _hovered_cell != cell: return
	_hovered_cell.self_modulate = Color(1.0, 0.914, 0.769)
	_hovered_cell = null
	EventBus.on_hover_on_item.emit(null)	
		
