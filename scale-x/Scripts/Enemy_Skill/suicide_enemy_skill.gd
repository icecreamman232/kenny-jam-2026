class_name SuicideEnemySkill extends EnemySkill

func get_skill_name() ->String: return "Suicide"

func get_skill_description() ->String: return "On dead, have 65% chance to remove one player item"

func remove() -> void:
	super.remove() 
	var should_remove_item:bool = randf_range(0, 100) <= 65
	if not should_remove_item: return
	var player_grid:PlayerGridUi = IngameDataManager.player_grid
	var available_cell:Array[PlayerCellGridUi] = []
	for cell_grid in player_grid.cell_grid:
		if cell_grid != null and cell_grid.assigned_item != null and not cell_grid.is_blocked:
			available_cell.append(cell_grid)
	
	if available_cell.size() == 0: return		
	var random_cell:PlayerCellGridUi = available_cell.pick_random()
	(IngameDataManager.text_manager as TextManager).show_text("Destroyed", random_cell.global_position, Color.DARK_GRAY)	
	AudioManager.play_sfx(SfxContainer.SfxID.NEGATIVE_MODIFIER)	
	random_cell.unassign_item()
	
	
