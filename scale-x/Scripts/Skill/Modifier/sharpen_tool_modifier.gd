class_name SharpenToolModifier extends Modifier

func _init():
	_mod_id = ModifierId.SharpenTool

func get_modifier_name() ->String: return "Sharpen Tool"

func get_modifier_description() -> String:
	return "At the end of round, repair 1 durability of random item"


func apply(cell:PlayerCellGridUi) ->void:
	super.apply(cell)
	EventBus.on_fight_end.connect(_on_fight_end)
	
	
func remove():
	EventBus.on_fight_end.disconnect(_on_fight_end)	
	
	
func _on_fight_end():
	var player_grid = IngameDataManager.player_grid

	var available_cell:Array[PlayerCellGridUi] = []
	for cell:PlayerCellGridUi in player_grid.cell_grid:
		if cell != null and cell.assigned_item != null:
			available_cell.append(cell)
	var random_cell:PlayerCellGridUi = available_cell.pick_random()
	random_cell.assigned_item.durability += 1
	random_cell._set_color_for_current_durability()
	(IngameDataManager.text_manager as TextManager).show_text("+1 Dur", random_cell.global_position)	
	AudioManager.play_sfx(SfxContainer.SfxID.POSITIVE_MODIFIER)
	random_cell.play_bounce_tween()