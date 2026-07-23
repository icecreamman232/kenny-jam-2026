class_name ChickenAttackEnemySkill extends EnemySkill

func get_skill_name() ->String: return "Chicken Attack!"

func get_skill_description() ->String: return "On attack, have 33% chance to reduce random item 3 armor"


func apply() -> void:
	EventBus.on_enemy_attack.connect(_on_enemy_attack)
	
func remove() -> void:
	EventBus.on_enemy_attack.disconnect(_on_enemy_attack)
	
	
func _on_enemy_attack() -> void:
	var is_triggered := randi_range(0,100) <= 33
	if not is_triggered: return
	var player_grid:PlayerGridUi = IngameDataManager.player_grid
	var random_cell:PlayerCellGridUi = player_grid.cell_grid.pick_random()
	if random_cell == null or random_cell.assigned_item == null: return
	random_cell.assigned_item.armor -= 3
	random_cell.play_bounce_tween()
	(IngameDataManager.text_manager as TextManager).show_text("-3 Armor", random_cell.global_position, Color.RED)
	AudioManager.play_sfx(SfxContainer.SfxID.NEGATIVE_MODIFIER)
	EventBus.on_recalculate_player_stat.emit()

