class_name PlayerGridUi extends Control

@export var cell_grid:Array[PlayerCellGridUi]
var _hovered_cell:PlayerCellGridUi

func _ready():
	for cell in cell_grid:
		cell.mouse_entered.connect(_on_mouse_entered_cell.bind(cell))
		cell.mouse_exited.connect(_on_mouse_exited_cell.bind(cell))
		
		
func _exit_tree() -> void:
	for cell in cell_grid:
		cell.mouse_entered.disconnect(_on_mouse_entered_cell.bind(cell))
		cell.mouse_exited.disconnect(_on_mouse_exited_cell.bind(cell))


func request_drop_item(item:ItemData) ->bool:
	if _hovered_cell == null: return false
	_hovered_cell.assign_item(item)
	EventBus.on_add_item.emit(_hovered_cell.grid_index, item)
	return true
	
	
func _on_mouse_entered_cell(cell:PlayerCellGridUi):
	_hovered_cell = cell
	print("HOVER ", cell.name)	

	
func _on_mouse_exited_cell(cell:PlayerCellGridUi) -> void:
	if _hovered_cell != cell: return
	_hovered_cell = null		