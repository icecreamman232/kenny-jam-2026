class_name SelfImproveModifier extends Modifier

func _init():
	_mod_id = ModifierId.SelfImprove


func get_modifier_name() ->String: return "Self Improve"

func get_modifier_description() -> String:
	return "+1 to lowest stat"
	
func apply(cell:PlayerCellGridUi) -> void:
	super.apply(cell)
	var player:PlayerController = IngameDataManager.gameplay_manager.player_controller
	var smallest_stat_dict:Dictionary[StatController.StatType, int] ={}
	smallest_stat_dict[StatController.StatType.ATTACK] = player.stat.get_final(StatController.StatType.ATTACK)
	smallest_stat_dict[StatController.StatType.ACCURACY] = player.stat.get_final(StatController.StatType.ACCURACY)
	smallest_stat_dict[StatController.StatType.SPEED] = player.stat.get_final(StatController.StatType.SPEED)
	smallest_stat_dict[StatController.StatType.LIFE] = player.stat.get_final(StatController.StatType.LIFE)
	smallest_stat_dict[StatController.StatType.DODGE] = player.stat.get_final(StatController.StatType.DODGE)
	smallest_stat_dict[StatController.StatType.ARMOR] = player.stat.get_final(StatController.StatType.ARMOR)
	
	var lowest_stat: StatController.StatType = smallest_stat_dict.keys()[0]
	for stat_type in smallest_stat_dict:
		if lowest_stat < smallest_stat_dict[stat_type]:
			lowest_stat = stat_type

	var lowest_stat_value:= player.stat.get_final(lowest_stat)
	lowest_stat_value += 1
	player.stat.set_final(lowest_stat, lowest_stat_value)
	IngameDataManager.text_manager.show_text("+1"  + StatController.get_stat_name(lowest_stat), player.player_pivot.global_position)
	AudioManager.play_sfx(SfxContainer.SfxID.POSITIVE_MODIFIER)
	EventBus.update_player_info.emit(player.stat)
