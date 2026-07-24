class_name TheTwinModifier extends Modifier

func _init():
	_mod_id = ModifierId.TheTwin


func get_modifier_name() ->String: return "The Twin"

func get_modifier_description() -> String:
	return "If left cell is weapon and rarity is same:\n +1 speed if it is Uncommon\n +2 speed if it is Rare\n +3 speed if it is Epic"
	
	
func apply(cell:PlayerCellGridUi) -> void:
	super.apply(cell)
	var self_index:int = _owner_cell.grid_index
	if self_index == 0 or self_index == 3 or self_index == 6: return
	var left_index:int = self_index - 1
	var left_cell:PlayerCellGridUi = IngameDataManager.player_grid.cell_grid[left_index]
	if left_cell.assigned_item == null: return
	if left_cell.assigned_item.rarity == _owner_cell.assigned_item.rarity:
		var bonus_speed:int = 0
		match _owner_cell.assigned_item.rarity:
			ItemData.ItemRarity.UNCOMMON: bonus_speed = 1
			ItemData.ItemRarity.RARE: bonus_speed = 2
			ItemData.ItemRarity.EPIC: bonus_speed = 3
		
		if bonus_speed == 0: return	
		_owner_cell.assigned_item.speed += bonus_speed
		(IngameDataManager.text_manager as TextManager).show_text("+1 Spd", _owner_cell.global_position)
		AudioManager.play_sfx(SfxContainer.SfxID.POSITIVE_MODIFIER)
		await _owner_cell.play_bounce_tween()
	

