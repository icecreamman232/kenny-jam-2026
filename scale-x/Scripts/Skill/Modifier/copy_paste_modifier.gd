class_name CopyPasteModifier extends Modifier

func _init():
	_mod_id = ModifierId.CopyPaste


func get_modifier_name() ->String: return "Copy Paste"

func get_modifier_description() -> String:
	return "Copy the stats of the item in the cell above"
	
func apply(cell:PlayerCellGridUi) -> void:
	super.apply(cell)
	var self_index:int = _owner_cell.grid_index
	if self_index == 0 or self_index == 1 or self_index == 2: return
	var above_index:int = self_index - 3
	var above_cell:PlayerCellGridUi = IngameDataManager.player_grid.cell_grid[above_index]
	if above_cell.assigned_item != null:
		_owner_cell.assigned_item.attack = above_cell.assigned_item.attack
		_owner_cell.assigned_item.accuracy = above_cell.assigned_item.accuracy
		_owner_cell.assigned_item.speed = above_cell.assigned_item.speed
		_owner_cell.assigned_item.life = above_cell.assigned_item.life
		_owner_cell.assigned_item.dodge = above_cell.assigned_item.dodge
		_owner_cell.assigned_item.armor = above_cell.assigned_item.armor
		(IngameDataManager.text_manager as TextManager).show_text("Copied", _owner_cell.global_position)
		AudioManager.play_sfx(SfxContainer.SfxID.POSITIVE_MODIFIER)
		EventBus.on_recalculate_player_stat.emit()
		await _owner_cell.play_bounce_tween()
	
