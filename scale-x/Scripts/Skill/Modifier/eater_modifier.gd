class_name EaterModifier extends Modifier

func _init():
	_mod_id = ModifierId.Eater


func get_modifier_name() ->String: return "Eater"

func get_modifier_description() -> String:
	return "Consume 1 random armor in grid.Stats will be merged"
	
func apply(cell:PlayerCellGridUi) -> void:
	super.apply(cell)
	var player_grid:PlayerGridUi = IngameDataManager.player_grid
	var available_cell:Array[PlayerCellGridUi] = []
	for cell_grid in player_grid.cell_grid:
		if cell_grid == null or cell_grid.assigned_item == null: continue
		if cell_grid == cell: continue
		if ItemData.is_weapon(cell_grid.assigned_item): continue
		available_cell.append(cell_grid)
		
		
	if available_cell.size() == 0: return
	var random_cell:PlayerCellGridUi = available_cell.pick_random()
	var item:ItemData = random_cell.assigned_item
	
	cell.assigned_item.attack += item.attack
	cell.assigned_item.accuracy += item.accuracy
	cell.assigned_item.speed += item.speed
	cell.assigned_item.life += item.life
	#cell.assigned_item.mana += item.mana
	cell.assigned_item.dodge += item.dodge
	cell.assigned_item.armor += item.armor

	EventBus.on_recalculate_player_stat.emit()	
	await cell.play_bounce_tween()
	
	
	(IngameDataManager.text_manager as TextManager).show_text("Consumed", random_cell.global_position)
	random_cell.unassign_item()	
