class_name LoneWolfModifier extends Modifier

var _bonus_armor:int = 0

func _init():
	_mod_id = ModifierId.LoneWolf
	EventBus.on_add_item_to_cell.connect(_on_add_item_to_cell)
	EventBus.on_remove_item_from_cell.connect(_on_remove_item_from_cell)

func get_modifier_name() ->String: return "Lone Wolf"

func get_modifier_description() -> String:
	return "Increase 1 armor for each adjacent empty cell"
	

func _on_add_item_to_cell(grid_index:int, item:ItemData) -> void:
	if grid_index == _owner_cell.grid_index: return
	var self_index:int = _owner_cell.grid_index
	var ajacent_cells_index:Array[int] = Helper.get_adjacent_cell_index(self_index)
	for idx in ajacent_cells_index:
		if grid_index != idx:continue
		_bonus_armor -= 1
		(IngameDataManager.text_manager as TextManager).show_text("-" + str(_bonus_armor) + " Armor", _owner_cell.global_position)
		AudioManager.play_sfx(SfxContainer.SfxID.NEGATIVE_MODIFIER)
		EventBus.on_recalculate_player_stat.emit()	
		await _owner_cell.play_bounce_tween()		
		break
	
	
func _on_remove_item_from_cell(grid_index:int, item:ItemData) -> void:
	if _owner_cell == null or _owner_cell.grid_index == grid_index or _owner_cell.assigned_item ==  null : return
	var self_index:int = _owner_cell.grid_index
	var ajacent_cells_index:Array[int] = Helper.get_adjacent_cell_index(self_index)
	for idx in ajacent_cells_index:
		if grid_index != idx:continue
		_bonus_armor += 1
		(IngameDataManager.text_manager as TextManager).show_text("+" + str(_bonus_armor) + " Armor", _owner_cell.global_position)
		AudioManager.play_sfx(SfxContainer.SfxID.POSITIVE_MODIFIER)
		EventBus.on_recalculate_player_stat.emit()		
		break

	
func apply(cell:PlayerCellGridUi):
	super.apply(cell)
	var self_index:int = _owner_cell.grid_index
	var ajacent_cells_index:Array[int] = Helper.get_adjacent_cell_index(self_index)
	var player_grid:PlayerGridUi = IngameDataManager.player_grid
	for idx in ajacent_cells_index:
		if player_grid.cell_grid[idx].assigned_item == null:
			_bonus_armor += 1
	(IngameDataManager.text_manager as TextManager).show_text("+" + str(_bonus_armor) + " Armor", _owner_cell.global_position)
	AudioManager.play_sfx(SfxContainer.SfxID.POSITIVE_MODIFIER)
	_owner_cell.assigned_item.armor += _bonus_armor
	EventBus.on_recalculate_player_stat.emit()	
	await _owner_cell.play_bounce_tween()	
	

func remove():
	super.remove()
	_owner_cell.assigned_item.armor -= _bonus_armor
	(IngameDataManager.text_manager as TextManager).show_text("-" + str(_bonus_armor) + " Armor", _owner_cell.global_position)
	AudioManager.play_sfx(SfxContainer.SfxID.NEGATIVE_MODIFIER)
	EventBus.on_recalculate_player_stat.emit()	
	EventBus.on_add_item_to_cell.disconnect(_on_add_item_to_cell)
	EventBus.on_remove_item_from_cell.disconnect(_on_remove_item_from_cell)		
