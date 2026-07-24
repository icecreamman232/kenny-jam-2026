class_name StatMasterShop extends Control

var stat_to_buy:Array[StatController.StatType] = []

func _ready():
	EventBus.on_open_npc_shop.connect(_on_open_npc_shop)
	
func _exit_tree() -> void:
	EventBus.on_open_npc_shop.disconnect(_on_open_npc_shop)
	
	
func _on_open_npc_shop(npc_id:NpcManager.NpcID) -> void:
	if npc_id != NpcManager.NpcID.STAT_MASTER: return
	
	var lowest_stat: StatController.StatType = _get_stat_that_player_has_lowest_value()
	stat_to_buy.append(lowest_stat)
	stat_to_buy.append(StatController.StatType.values().pick_random())
	stat_to_buy.append(StatController.StatType.values().pick_random())
	show()



func _get_stat_that_player_has_lowest_value() -> StatController.StatType:
	var player: PlayerController = IngameDataManager.gameplay_manager.player_controller
	
	var stats := {
		StatController.StatType.ATTACK: player.stat.get_final(StatController.StatType.ATTACK),
		StatController.StatType.ACCURACY: player.stat.get_final(StatController.StatType.ACCURACY),
		StatController.StatType.SPEED: player.stat.get_final(StatController.StatType.SPEED),
		StatController.StatType.LIFE: player.stat.get_final(StatController.StatType.LIFE),
		StatController.StatType.DODGE: player.stat.get_final(StatController.StatType.DODGE),
		StatController.StatType.ARMOR: player.stat.get_final(StatController.StatType.ARMOR),
	}

	var lowest_stat: StatController.StatType = stats.keys()[0]
	var lowest_value: float = stats[lowest_stat]

	for stat_type in stats:
		if stats[stat_type] < lowest_value:
			lowest_value = stats[stat_type]
			lowest_stat = stat_type

	return lowest_stat
