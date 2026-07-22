class_name DeathIsNotTheEndModifier extends Modifier

func _init():
	_mod_id = ModifierId.DeathIsNotTheEnd


func get_modifier_name() ->String: return "Death is not the end"

func get_modifier_description() -> String:
	return "Set item stats to 0. +1 random stat for each item being removed"
	
func apply(cell:PlayerCellGridUi) -> void:
	super.apply(cell)
	_owner_cell.assigned_item.durability = 0
	_owner_cell.assigned_item.attack = 0
	_owner_cell.assigned_item.accuracy = 0
	_owner_cell.assigned_item.speed = 0
	_owner_cell.assigned_item.life = 0
	_owner_cell.assigned_item.mana = 0
	_owner_cell.assigned_item.dodge = 0
	_owner_cell.assigned_item.armor = 0
	EventBus.on_remove_item_from_cell.connect(_on_remove_item_from_cell)


func remove():
	super.remove()
	EventBus.on_remove_item_from_cell.disconnect(_on_remove_item_from_cell)
	

func _on_remove_item_from_cell(grid_index:int, item:ItemData) -> void:
	if _owner_cell == null or _owner_cell.grid_index == grid_index or _owner_cell.assigned_item ==  null or _owner_cell.assigned_item == item: return	
	var random_stat_index:int  = randi_range(0,6 )
	var stat_name:String
	match random_stat_index:
		0: 
			_owner_cell.assigned_item.attack += 1
			stat_name = "Atk"
		1: 
			_owner_cell.assigned_item.accuracy += 1
			stat_name = "Acc"
		2:
			_owner_cell.assigned_item.speed += 1
			stat_name = "Spd"
		3: 
			_owner_cell.assigned_item.life += 1
			stat_name = "Life"
		4: 
			_owner_cell.assigned_item.mana += 1
			stat_name = "Mana"
		5: 
			_owner_cell.assigned_item.dodge += 1
			stat_name = "Dodge"
		6: 
			_owner_cell.assigned_item.armor += 1
			stat_name = "Armor"
	
	(IngameDataManager.text_manager as TextManager).show_text("+1" + stat_name, _owner_cell.global_position)	
	AudioManager.play_sfx(SfxContainer.SfxID.POSITIVE_MODIFIER)
	await _owner_cell.play_bounce_tween()	
	EventBus.on_recalculate_player_stat.emit()		
