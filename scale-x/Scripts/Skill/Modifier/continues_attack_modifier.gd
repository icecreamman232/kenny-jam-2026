class_name ContinuesAttackModifier extends Modifier

var _bonus_attack:int = 0

func _init():
	_mod_id = ModifierId.ContinuesAttack


func get_modifier_name() ->String: return "Continues Attack"

func get_modifier_description() -> String:
	return "+1 attack after each round. Have 45% chance to be destroyed after round ended"


func apply(cell:PlayerCellGridUi):
	super.apply(cell)
	EventBus.on_fight_end.connect(_on_fight_end)

	
func remove():
	super.remove()
	EventBus.on_fight_end.disconnect(_on_fight_end)
	_owner_cell.assigned_item.attack -= _bonus_attack
	_bonus_attack = 0
	
	
func _on_fight_end() -> void:
	_bonus_attack += 1
	_owner_cell.assigned_item.attack += 1
	(IngameDataManager.text_manager as TextManager).show_text("+1 Atk", _owner_cell.global_position)	
	AudioManager.play_sfx(SfxContainer.SfxID.POSITIVE_MODIFIER)
	EventBus.on_recalculate_player_stat.emit()
	await _owner_cell.play_bounce_tween()	
	
	var chance:float = randf_range(0, 100)
	if chance > 65: return
	_owner_cell.unassign_item()
	EventBus.on_recalculate_player_stat.emit()
	(IngameDataManager.text_manager as TextManager).show_text("Destroyed", _owner_cell.global_position, Color.DARK_GRAY)	
	AudioManager.play_sfx(SfxContainer.SfxID.NEGATIVE_MODIFIER)	
	