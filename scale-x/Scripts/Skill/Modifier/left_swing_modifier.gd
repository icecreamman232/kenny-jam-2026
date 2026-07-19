class_name LeftSwingModifier extends Modifier

func _init(): _mod_id = ModifierId.LeftSwing

func get_modifier_name() ->String: return "Left Swing"

func get_modifier_description() -> String:
	return "+1 attack to weapon on the left"
	
func apply(cell:PlayerCellGridUi):
	super.apply(cell)
	var self_index:int = _owner_cell.grid_index
	if self_index == 0 or self_index == 3 or self_index == 6: return
	var left_index:int = self_index - 1
	var player_grid:PlayerGridUi = IngameDataManager.player_grid
	if player_grid.cell_grid[left_index].assigned_item != null:
		if ItemData.is_weapon(player_grid.cell_grid[left_index].assigned_item):
			player_grid.cell_grid[left_index].assigned_item.attack += 1
			(IngameDataManager.text_manager as TextManager).show_text("+1 Atk", player_grid.cell_grid[left_index].global_position)
			AudioManager.play_sfx(SfxContainer.SfxID.POSITIVE_MODIFIER)
			EventBus.on_recalculate_player_stat.emit()	
			await player_grid.cell_grid[left_index].play_bounce_tween()		
			

func remove():
	super.remove()	
	var self_index:int = _owner_cell.grid_index
	var left_index:int = self_index - 1
	var player_grid:PlayerGridUi = IngameDataManager.player_grid
	if player_grid.cell_grid[left_index].assigned_item != null:
		if ItemData.is_weapon(player_grid.cell_grid[left_index].assigned_item):
			player_grid.cell_grid[left_index].assigned_item.attack -= 1
			(IngameDataManager.text_manager as TextManager).show_text("-1 Atk", player_grid.cell_grid[left_index].global_position)
			AudioManager.play_sfx(SfxContainer.SfxID.NEGATIVE_MODIFIER)
			EventBus.on_recalculate_player_stat.emit()	

