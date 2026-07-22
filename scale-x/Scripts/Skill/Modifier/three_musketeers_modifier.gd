class_name ThreeMusketeersModifier extends Modifier

func _init():
	_mod_id = ModifierId.ThreeMusketeers

func get_modifier_name() ->String: return "Sharpen Tool"

func get_modifier_description() -> String:
	return "On equip, if left cell and right cell both are weapon, consume them"
	
func apply(cell:PlayerCellGridUi):
	super.apply(cell)
	var player_grid:PlayerGridUi = IngameDataManager.player_grid
	var self_index:int = _owner_cell.grid_index
	var left_index:int = -1
	var right_index:int = -1
	
	if self_index == 0 or self_index == 3 or self_index == 6:
		right_index = self_index + 1
	elif self_index == 1 or self_index == 4 or self_index == 7:
		left_index = self_index - 1
		right_index = self_index + 1
	elif self_index == 2 or self_index == 5 or self_index == 8:
		left_index = self_index - 1
	if left_index != -1:
		var left_cell:PlayerCellGridUi = player_grid.cell_grid[left_index]
		if ItemData.is_weapon(left_cell.assigned_item):
			_owner_cell.assigned_item.attack += left_cell.assigned_item.attack
			_owner_cell.assigned_item.speed += left_cell.assigned_item.speed
			_owner_cell.assigned_item.accuracy += left_cell.assigned_item.accuracy
			_owner_cell.assigned_item.life += left_cell.assigned_item.life
			#_owner_cell.assigned_item.mana += left_cell.assigned_item.mana
			_owner_cell.assigned_item.dodge += left_cell.assigned_item.dodge
			_owner_cell.assigned_item.armor += left_cell.assigned_item.armor
			EventBus.on_recalculate_player_stat.emit()
			AudioManager.play_sfx(SfxContainer.SfxID.POSITIVE_MODIFIER)
			(IngameDataManager.text_manager as TextManager).show_text("Consumed", left_cell.global_position)
			left_cell.play_bounce_tween()	
			left_cell.unassign_item()
		
	if right_index != -1:
		var right_cell:PlayerCellGridUi = player_grid.cell_grid[right_index]
		if ItemData.is_weapon(right_cell.assigned_item):
			_owner_cell.assigned_item.attack += right_cell.assigned_item.attack
			_owner_cell.assigned_item.speed += right_cell.assigned_item.speed
			_owner_cell.assigned_item.accuracy += right_cell.assigned_item.accuracy
			_owner_cell.assigned_item.life += right_cell.assigned_item.life
			#_owner_cell.assigned_item.mana += right_cell.assigned_item.mana
			_owner_cell.assigned_item.dodge += right_cell.assigned_item.dodge
			_owner_cell.assigned_item.armor += right_cell.assigned_item.armor
			EventBus.on_recalculate_player_stat.emit()
			AudioManager.play_sfx(SfxContainer.SfxID.POSITIVE_MODIFIER)
			(IngameDataManager.text_manager as TextManager).show_text("Consumed", right_cell.global_position)
			right_cell.play_bounce_tween()	
			right_cell.unassign_item()	
		