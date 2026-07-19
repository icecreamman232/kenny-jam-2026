class_name MultiHandModifier extends Modifier

# Increase adjacent weapon cell attack by 1

func _init():
	_mod_id = ModifierId.MultiHand


func apply(cell:PlayerCellGridUi):
	super.apply(cell)
	var self_index:int = _owner_cell.grid_index
	var ajacent_cells_index:Array[int] = Helper.get_adjacent_cell_index(self_index)
	var player_grid:PlayerGridUi = IngameDataManager.player_grid
	for idx in ajacent_cells_index:
		if player_grid.cell_grid[idx].assigned_item != null:
			if ItemData.is_weapon(player_grid.cell_grid[idx].assigned_item):
				player_grid.cell_grid[idx].assigned_item.attack += 1
				print("Apply MultiHandModifier to cell ", idx)
				EventBus.on_recalculate_player_stat.emit()
				
				
func remove():
	super.remove()
	var self_index:int = _owner_cell.grid_index
	var ajacent_cells_index:Array[int] = Helper.get_adjacent_cell_index(self_index)
	var player_grid:PlayerGridUi = IngameDataManager.player_grid
	for idx in ajacent_cells_index:
		if player_grid.cell_grid[idx].assigned_item != null:
			if ItemData.is_weapon(player_grid.cell_grid[idx].assigned_item):
				player_grid.cell_grid[idx].assigned_item.attack -= 1
				print("Remove MultiHandModifier to cell ", idx)
				EventBus.on_recalculate_player_stat.emit()	
			
