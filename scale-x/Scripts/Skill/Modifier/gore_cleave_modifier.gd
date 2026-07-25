class_name GoreCleaveModifier extends Modifier

func _init():
	_mod_id = ModifierId.SpearHead


func get_modifier_name() ->String: return "Gore Cleave"

func get_modifier_description() -> String:
	return "Sacrifice 1 life to buff random item 1 attack for each turn"
	
	
func trigger() -> void:
	super.trigger()
	var player:PlayerController = IngameDataManager.gameplay_manager.player_controller
	if player.health.current_life <= 1: return
	player.health.spent_life(1)
	
	var player_grid:PlayerGridUi = IngameDataManager.player_grid
	var available_cells:Array[PlayerCellGridUi] = []
	for cell in player_grid.cell_grid:
		if cell != null and cell.assigned_item != null:
			available_cells.append(cell)
	
	if available_cells.size() == 0: return
	
	var random_cell:PlayerCellGridUi = available_cells.pick_random()
	random_cell.assigned_item.attack += 1
	EventBus.on_recalculate_player_stat.emit()
	random_cell.play_bounce_tween()
	(IngameDataManager.text_manager as TextManager).show_text("+1 Atk", random_cell.global_position)
	AudioManager.play_sfx(SfxContainer.SfxID.POSITIVE_MODIFIER)	
	
	