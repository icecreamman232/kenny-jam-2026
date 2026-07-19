class_name RightSwingModifier extends Modifier

func _init(): _mod_id = ModifierId.RightSwing

func get_modifier_name() ->String: return "Right Swing"

func get_modifier_description() -> String:
	return "+1 attack to weapon on the right"
	
func apply(cell:PlayerCellGridUi) -> void:
	super.apply(cell)
	var self_index:int = _owner_cell.grid_index
	if self_index == 2 or self_index == 5 or self_index == 8: return
	var right_index:int = self_index + 1
	var player_grid:PlayerGridUi = IngameDataManager.player_grid
	if player_grid.cell_grid[right_index].assigned_item != null:
		if ItemData.is_weapon(player_grid.cell_grid[right_index].assigned_item):
			player_grid.cell_grid[right_index].assigned_item.attack += 1
			(IngameDataManager.text_manager as TextManager).show_text("+1 Atk", player_grid.cell_grid[right_index].global_position)
			EventBus.on_recalculate_player_stat.emit()	
			await player_grid.cell_grid[right_index].play_bounce_tween()		
			

func remove() -> void:
	super.remove()	
	var self_index:int = _owner_cell.grid_index
	var right_index:int = self_index + 1
	if self_index % 3 == 0: return
	var player_grid:PlayerGridUi = IngameDataManager.player_grid
	if player_grid.cell_grid[right_index].assigned_item != null:
		if ItemData.is_weapon(player_grid.cell_grid[right_index].assigned_item):
			player_grid.cell_grid[right_index].assigned_item.attack -= 1
			(IngameDataManager.text_manager as TextManager).show_text("-1 Atk", player_grid.cell_grid[right_index].global_position)
			EventBus.on_recalculate_player_stat.emit()	