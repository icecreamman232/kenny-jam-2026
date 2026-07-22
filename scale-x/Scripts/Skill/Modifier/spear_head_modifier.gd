class_name SpearHeadModifier extends Modifier

var _block_cell:PlayerCellGridUi

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
	left_index = self_index - 1
	if left_index < 0: left_index = -1
	right_index = self_index + 1
	if right_index > 8: right_index = -1
	var player_grid:PlayerGridUi = IngameDataManager.player_grid
	if left_index!= -1 and  player_grid.cell_grid[left_index].assigned_item != null:
		player_grid.cell_grid[left_index].assigned_item.attack += 3
		(IngameDataManager.text_manager as TextManager).show_text("+3 Atk", player_grid.cell_grid[left_index].global_position)
		AudioManager.play_sfx(SfxContainer.SfxID.POSITIVE_MODIFIER)
		EventBus.on_recalculate_player_stat.emit()	
		await player_grid.cell_grid[left_index].play_bounce_tween()
	
	await Helper.wait_for_seconds(0.1)
		
	if right_index != -1 :
		_block_cell = player_grid.cell_grid[right_index]
		player_grid.cell_grid[right_index].set_block(true)
		(IngameDataManager.text_manager as TextManager).show_text("Blocked", player_grid.cell_grid[right_index].global_position, Color(0.111, 0.111, 0.111))
		AudioManager.play_sfx(SfxContainer.SfxID.NEGATIVE_MODIFIER)
		EventBus.on_recalculate_player_stat.emit()	
		await player_grid.cell_grid[right_index].play_bounce_tween()	
		
		
func remove() -> void:
	super.remove()
	if _block_cell == null: return
	AudioManager.play_sfx(SfxContainer.SfxID.POSITIVE_MODIFIER)
	(IngameDataManager.text_manager as TextManager).show_text("Unblock", _block_cell.global_position)
	_block_cell.set_block(false)	
	await _block_cell.play_bounce_tween()	
	_block_cell = null
			
	
