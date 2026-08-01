class_name TryHardModifier extends Modifier

func _init():
	_mod_id = ModifierId.TryHard

func get_modifier_name() ->String: return "Tryhard"

func get_modifier_description() -> String:
	return "+1 attack if player hit miss"
	
	
func apply(cell:PlayerCellGridUi) -> void:
	super.apply(cell)
	EventBus.on_player_miss_attack.connect(_on_player_hit_miss)
	
	
func remove():
	super.remove()
	EventBus.on_player_miss_attack.disconnect(_on_player_hit_miss)	
		

func _on_player_hit_miss() -> void:
	_owner_cell.assigned_item.attack += 1
	(IngameDataManager.text_manager as TextManager).show_text("+1 Atk", _owner_cell.global_position)
	AudioManager.play_sfx(SfxContainer.SfxID.POSITIVE_MODIFIER)
	EventBus.on_recalculate_player_stat.emit()	
	await _owner_cell.play_bounce_tween()	
