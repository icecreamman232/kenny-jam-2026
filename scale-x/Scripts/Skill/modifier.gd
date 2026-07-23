class_name Modifier extends RefCounted

enum ModifierId
{
	MultiHand,
	LeftSwing,
	RightSwing,
	LoneWolf,
	ContinuesAttack,
	SpearHead,
	Eater,
	DeathIsNotTheEnd,
	SharpenTool,
	ThreeMusketeers,
}



var id:String
var _mod_id:ModifierId
var _owner_cell:PlayerCellGridUi

# Apply modifier to cell on equip. This is called only one time on equip
func apply(cell:PlayerCellGridUi): 
	_owner_cell = cell
	id = "cell_" + str(cell.grid_index) + "_" + Helper.print_enum(Modifier.ModifierId, _mod_id)

# Suppose to call before player attack or called by other events
func trigger() -> void:
	# Blocked cell wont be triggered
	if _owner_cell != null and _owner_cell.is_blocked: return 
	await Helper.wait_for_frames(1)


func remove(): pass


func get_modifier_name() ->String: return ""


func get_modifier_description() ->String: return ""


func get_whole_mod_desc() ->String:
	return "[font_size=32][color=yellow]" + get_modifier_name() +"[/color][/font_size][br]" + get_modifier_description()
