class_name LootBoxUI extends Control

@export var loot_manager:LootManager
@export var player_grid_ui:PlayerGridUi
@export var context_cursor:TextureRect
@export var loot_box_cell_ui:Array[LootBoxCellUi]


var _inspecting_cell:LootBoxCellUi
var _dragging:bool = false
var _drag_offset:Vector2 = Vector2.ZERO
const CELL_SIZE:float = 80

func _ready():
	for cell in loot_box_cell_ui:
		cell.mouse_entered.connect(_on_mouse_entered_cell.bind(cell))
		cell.mouse_exited.connect(_on_mouse_exited_cell.bind(cell))


func _exit_tree() ->void:
	for cell in loot_box_cell_ui:
		cell.mouse_entered.disconnect(_on_mouse_entered_cell.bind(cell))
		cell.mouse_exited.disconnect(_on_mouse_exited_cell.bind(cell))


func _input(event:InputEvent) -> void:
	if not visible: return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_dragging = event.pressed
			if _dragging:
				if _inspecting_cell!= null and _inspecting_cell.assigned_item != null:
					context_cursor.texture = _inspecting_cell.assigned_item.item_icon
					_drag_offset = _inspecting_cell.global_position - get_global_mouse_position()
					context_cursor.global_position = _get_dragged_position()
					context_cursor.show()
			else:
				if _inspecting_cell != null and _inspecting_cell.assigned_item != null:
					var result := player_grid_ui.request_drop_item(_inspecting_cell.assigned_item)
					if result:
						context_cursor.hide()
						_inspecting_cell.unassign_item()
						_inspecting_cell = null
					
		get_viewport().set_input_as_handled()
	elif event is InputEventMouseMotion and _dragging:
		if _inspecting_cell != null:
			context_cursor.global_position = _get_dragged_position()


func show_loot():
	var loot_items:= loot_manager.get_items()
	for idx in range(loot_items.size()):
		loot_box_cell_ui[idx].assign_item(loot_items[idx])


func _get_dragged_position() -> Vector2:
	return get_global_mouse_position() + _drag_offset
		
		
func _on_mouse_entered_cell(cell:LootBoxCellUi):
	_inspecting_cell = cell
	
	
func _on_mouse_exited_cell(cell:LootBoxCellUi) -> void:
	if _inspecting_cell != cell: return
