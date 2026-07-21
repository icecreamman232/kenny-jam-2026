class_name SpearHeadModifier extends Modifier

func _init():
	_mod_id = ModifierId.SpearHead


func get_modifier_name() ->String: return "Spear Head"

func get_modifier_description() -> String:
	return "+3 Atk to weapon on the left. Block the cell on the right"

func apply(cell:PlayerCellGridUi):
	super.apply(cell)
	var right_index:int = -1
	var left_index:int = -1
	var self_index:int = _owner_cell.grid_index
	if self_index != 0 and self_index != 3 or self_index != 6:
		left_index = self_index - 1
	if self_index != 2 and self_index != 5 or self_index != 8:
		right_index = self_index + 1
	var player_grid:PlayerGridUi = IngameDataManager.player_grid
	if left_index!= -1 and  player_grid.cell_grid[left_index].assigned_item != null:
		player_grid.cell_grid[left_index].assigned_item.attack += 3
		(IngameDataManager.text_manager as TextManager).show_text("+3 Atk", player_grid.cell_grid[left_index].global_position)
		AudioManager.play_sfx(SfxContainer.SfxID.POSITIVE_MODIFIER)
		EventBus.on_recalculate_player_stat.emit()	
		await player_grid.cell_grid[left_index].play_bounce_tween()
		
	if right_index != -1 :
		player_grid.cell_grid[right_index].set_block(true)
		(IngameDataManager.text_manager as TextManager).show_text("Blocked", player_grid.cell_grid[left_index].global_position, Color(0.111, 0.111, 0.111))
		AudioManager.play_sfx(SfxContainer.SfxID.NEGATIVE_MODIFIER)
		EventBus.on_recalculate_player_stat.emit()	
		await player_grid.cell_grid[right_index].play_bounce_tween()		
	
