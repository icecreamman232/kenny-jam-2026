class_name ChopdownModifier extends Modifier

var _has_triggered:bool = false

func _init():
	_mod_id = ModifierId.ChopDown


func get_modifier_name() ->String: return "Chop Down"

func get_modifier_description() -> String:
	return "If destroy item on the left then it will reduce enemy armor by 3.Trigger once"
	
	
func apply(cell:PlayerCellGridUi) -> void:
	super.apply(cell)
	if _has_triggered: return
	var self_index:int = _owner_cell.grid_index
	if self_index == 0 or self_index == 3 or self_index == 6: return
	var left_index:int = self_index - 1
	var player_grid:PlayerGridUi = IngameDataManager.player_grid
	if player_grid.cell_grid[left_index].assigned_item != null:
		var left_cell:= player_grid.cell_grid[left_index]
		left_cell.unassign_item()
		AudioManager.play_sfx(SfxContainer.SfxID.POSITIVE_MODIFIER)
		EventBus.on_recalculate_player_stat.emit()
		
		var enemy:= IngameDataManager.gameplay_manager.enemy_controller as EnemyController
		var cur_enemy_armor:= enemy.stat.get_final(StatController.StatType.ARMOR)
		cur_enemy_armor -= 3
		if cur_enemy_armor <= 0: cur_enemy_armor = 0
		enemy.stat.set_final(StatController.StatType.ARMOR, cur_enemy_armor)
		(IngameDataManager.text_manager as TextManager).show_text("-3 Armor", enemy.enemy_pivot.global_position, Color.RED)
		EventBus.update_enemy_info.emit(enemy.stat)	
		_has_triggered = true
