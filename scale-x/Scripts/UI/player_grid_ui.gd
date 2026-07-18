class_name PlayerGridUi extends Control

@export var fight_button:Button
@export var cell_grid:Array[PlayerCellGridUi]
var _hovered_cell:PlayerCellGridUi

func _ready():
	fight_button.pressed.connect(_on_fight_button_pressed)
	for cell in cell_grid:
		cell.mouse_entered.connect(_on_mouse_entered_cell.bind(cell))
		cell.mouse_exited.connect(_on_mouse_exited_cell.bind(cell))
		
		
func _exit_tree() -> void:
	fight_button.pressed.disconnect(_on_fight_button_pressed)
	for cell in cell_grid:
		cell.mouse_entered.disconnect(_on_mouse_entered_cell.bind(cell))
		cell.mouse_exited.disconnect(_on_mouse_exited_cell.bind(cell))


func request_drop_item(item:ItemData) ->bool:
	if _hovered_cell == null: return false
	_hovered_cell.assign_item(item)
	EventBus.on_add_item.emit(_hovered_cell.grid_index, item)
	return true


func _on_fight_button_pressed():
	print("Fight button pressed")
	EventBus.on_fight_started.emit()
	
	
func _on_mouse_entered_cell(cell:PlayerCellGridUi):
	_hovered_cell = cell

	
func _on_mouse_exited_cell(cell:PlayerCellGridUi) -> void:
	if _hovered_cell != cell: return
	_hovered_cell = null		