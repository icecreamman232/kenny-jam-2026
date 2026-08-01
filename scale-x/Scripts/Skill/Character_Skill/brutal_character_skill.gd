class_name BrutalCharacterSkill extends PlayerSkill

var _round_counter:int = 0

func get_skill_name() -> String: return "Brutal"

func get_skill_description() -> String: return "Sacrifice 2 life and add random 1-3 attack to a random item for every 5 rounds"

func apply() -> void: 
	super.apply()
	if not EventBus.on_new_round.is_connected(_on_new_round):
		EventBus.on_new_round.connect(_on_new_round)
	
	
func remove() -> void:
	if EventBus.on_new_round.is_connected(_on_new_round):
		EventBus.on_new_round.disconnect(_on_new_round)


func _on_new_round():
	_round_counter += 1
	if _round_counter % 5 == 0:
		var player:PlayerController = IngameDataManager.gameplay_manager.player_controller
		player.health.spent_life(2)
		var random_attack_gain:int = randi_range(1, 3)
		var random_cell:PlayerCellGridUi = _get_random_available_cell()
		if random_cell != null:
			random_cell.assigned_item.attack += random_attack_gain
			(IngameDataManager.text_manager as TextManager).show_text("+" + str(random_attack_gain) + " Atk", random_cell.global_position)
			random_cell.play_bounce_tween()
			AudioManager.play_sfx(SfxContainer.SfxID.POSITIVE_MODIFIER)
		
		EventBus.update_player_info.emit(player.stat)
		_round_counter = 0
		
		
func _get_random_available_cell() -> PlayerCellGridUi:
	var player_grid:PlayerGridUi = IngameDataManager.gameplay_manager.player_grid
	var available_cells:Array[PlayerCellGridUi] = []
	for cell in player_grid.cell_grid:
		if cell != null and cell.assigned_item != null:
			available_cells.append(cell)
	if available_cells.size() == 0: return null
	return available_cells.pick_random()
