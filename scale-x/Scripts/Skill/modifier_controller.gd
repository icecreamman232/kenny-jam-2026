class_name ModifierController extends Node

var modifier_list:Dictionary[String, Modifier] = {}
var modifier_by_cell:Dictionary[int, Array] = {}

func _ready():
	IngameDataManager.modifier_controller = self
	for i in range(9):
		modifier_by_cell[i] = []
		
	
func add_modifier(modifier:Modifier):
	if not modifier_list.has(modifier.id):
		modifier_list[modifier.id] = modifier
		modifier_by_cell[modifier._owner_cell.grid_index].append(modifier)


func remove_modifier(id:String):
	var modifier:Modifier = modifier_list[id]
	modifier_by_cell[modifier._owner_cell.grid_index].erase(modifier)
	modifier_list.erase(id)
	

func trigger_modifiers():
	for i in range(9):
		for mod in modifier_by_cell[i]:
			await (mod as Modifier).trigger()
			await Helper.wait_for_seconds(0.05)
			
