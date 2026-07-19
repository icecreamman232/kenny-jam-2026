class_name MultiHandModifier extends Modifier

func _init():
	_mod_id = ModifierId.MultiHand


func get_modifier_name() ->String: return "Multi Hands"

func get_modifier_description() -> String:
	return "+1 attack to adjacent weapon"


func apply(cell:PlayerCellGridUi):
	super.apply(cell)
	var self_index:int = _owner_cell.grid_index
	var ajacent_cells_index:Array[int] = Helper.get_adjacent_cell_index(self_index)
	var player_grid:PlayerGridUi = IngameDataManager.player_grid
	for idx in ajacent_cells_index:
		if player_grid.cell_grid[idx].assigned_item != null:
			if ItemData.is_weapon(player_grid.cell_grid[idx].assigned_item):
				player_grid.cell_grid[idx].assigned_item.attack += 1
				(IngameDataManager.text_manager as TextManager).show_text("+1 Atk", player_grid.cell_grid[idx].global_position)
				AudioManager.play_sfx(SfxContainer.SfxID.POSITIVE_MODIFIER)
				EventBus.on_recalculate_player_stat.emit()	
				await player_grid.cell_grid[idx].play_bounce_tween()
				
				
func remove():
	super.remove()
	var self_index:int = _owner_cell.grid_index
	var ajacent_cells_index:Array[int] = Helper.get_adjacent_cell_index(self_index)
	var player_grid:PlayerGridUi = IngameDataManager.player_grid
	for idx in ajacent_cells_index:
		if player_grid.cell_grid[idx].assigned_item != null:
			if ItemData.is_weapon(player_grid.cell_grid[idx].assigned_item):
				player_grid.cell_grid[idx].assigned_item.attack -= 1
				(IngameDataManager.text_manager as TextManager).show_text("-1 Atk", player_grid.cell_grid[idx].global_position)
				AudioManager.play_sfx(SfxContainer.SfxID.NEGATIVE_MODIFIER)
				EventBus.on_recalculate_player_stat.emit()	
				
			
