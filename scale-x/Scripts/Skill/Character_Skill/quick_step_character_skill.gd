class_name QuickStepCharacterSkill extends PlayerSkill

var _round_counter:int = 0

func get_skill_name() -> String: return "Quick Step"

func get_skill_description() -> String: return "+1 Speed every 6 rounds"

func apply() -> void: 
	super.apply()
	if not EventBus.on_new_round.is_connected(_on_new_round):
		EventBus.on_new_round.connect(_on_new_round)
	
	
func remove() -> void:
	if EventBus.on_new_round.is_connected(_on_new_round):
		EventBus.on_new_round.disconnect(_on_new_round)


func _on_new_round():
	_round_counter += 1
	if _round_counter % 6 == 0:
		var player:PlayerController = IngameDataManager.gameplay_manager.player_controller
		var current_spd := player.stat.get_final(StatController.StatType.SPEED)
		current_spd += 1
		player.stat.set_final(StatController.StatType.SPEED, current_spd)
		EventBus.update_player_info.emit(player.stat)
		_round_counter = 0