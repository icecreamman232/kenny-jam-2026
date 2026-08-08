class_name OverPowerModifier extends Modifier

func _init():
	_mod_id = ModifierId.OverPower

func get_modifier_name() ->String: return "OverPower"

func get_modifier_description() -> String:
	return "Start with 6 attack, decrease over time. Blocked left and right cell"
	
func apply(cell:PlayerCellGridUi):
	super.apply(cell)
	_owner_cell.assigned_item.attack = 6
	EventBus.on_recalculate_player_stat.emit()
	_owner_cell.play_bounce_tween()	
	
	var self_index := _owner_cell.grid_index
	var left_index:= -1
	var right_index:=-1
	if self_index == 1 or self_index == 4 or self_index == 7:
		left_index = self_index - 1
		right_index = self_index + 1
	elif self_index == 0 or self_index == 3 or self_index == 6:
		right_index = self_index + 1
	elif self_index == 2 or self_index == 5 or self_index == 8:
		left_index = self_index - 1
		
	var player_grid:= IngameDataManager.player_grid	as PlayerGridUi
	
	if left_index != -1:	
		var left_cell:PlayerCellGridUi = player_grid.cell_grid[left_index]
		left_cell.set_block(true)
		AudioManager.play_sfx(SfxContainer.SfxID.NEGATIVE_MODIFIER)
		(IngameDataManager.text_manager as TextManager).show_text("Blocked", left_cell.global_position, Color(0.111, 0.111, 0.111))
		left_cell.play_bounce_tween()	
	if right_index != -1:
		var right_cell:PlayerCellGridUi =  player_grid.cell_grid[right_index]
		right_cell.set_block(true)
		AudioManager.play_sfx(SfxContainer.SfxID.NEGATIVE_MODIFIER)
		(IngameDataManager.text_manager as TextManager).show_text("Blocked", right_cell.global_position, Color(0.111, 0.111, 0.111))
		right_cell.play_bounce_tween()
		
		
func trigger() -> void:
	if _owner_cell.assigned_item.attack <= 0: return
	
	_owner_cell.assigned_item.attack -= 1
	if _owner_cell.assigned_item.attack <= 0:
		_owner_cell.assigned_item.attack = 0
		
	EventBus.on_recalculate_player_stat.emit()
	(IngameDataManager.text_manager as TextManager).show_text("-1 Atk", _owner_cell.global_position, Color.RED)
	_owner_cell.play_bounce_tween()	
		
		
func remove() ->void:
	super.remove()
	var self_index := _owner_cell.grid_index
	var left_index:= -1
	var right_index:=-1
	if self_index != 0:
		left_index = self_index - 1
	if self_index != 8:
		right_index = self_index + 1
	var player_grid:= IngameDataManager.player_grid	as PlayerGridUi
	
	if left_index != -1:	
		var left_cell:PlayerCellGridUi = player_grid.cell_grid[left_index]
		left_cell.set_block(false)
		AudioManager.play_sfx(SfxContainer.SfxID.POSITIVE_MODIFIER)
		(IngameDataManager.text_manager as TextManager).show_text("Unblock", left_cell.global_position)
		left_cell.play_bounce_tween()	
	if right_index != -1:
		var right_cell:PlayerCellGridUi =  player_grid.cell_grid[right_index]
		right_cell.set_block(false)
		AudioManager.play_sfx(SfxContainer.SfxID.POSITIVE_MODIFIER)
		(IngameDataManager.text_manager as TextManager).show_text("Unblock", right_cell.global_position)
		right_cell.play_bounce_tween()
	