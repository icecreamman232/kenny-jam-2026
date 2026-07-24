class_name FairFightEnemySkill extends EnemySkill

func get_skill_name() ->String: return "Fair Fight"

func get_skill_description() ->String: return "On appear, get a buff that make enemy life is equal to player life"

func apply() -> void:
	super.apply()
	var player:PlayerController = IngameDataManager.gameplay_manager.player_controller
	var player_life := player.stat.get_final(StatController.StatType.LIFE)
	var enemy_life := _enemy_controller.stat.get_final(StatController.StatType.LIFE)
	if player_life > enemy_life:
		var difference := player_life - enemy_life
		_enemy_controller.health.add_max_health(difference)
		(IngameDataManager.text_manager as TextManager).show_text("+" + str(difference) + " Life", _enemy_controller.enemy_pivot.global_position)
		EventBus.update_enemy_info.emit(_enemy_controller.stat)
	