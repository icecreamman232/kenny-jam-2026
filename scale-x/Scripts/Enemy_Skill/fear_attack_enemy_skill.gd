class_name FearAttackEnemySkill extends EnemySkill

func get_skill_name() ->String: return "Fear"

func get_skill_description() ->String: return "On appear, -2 player attack"

func apply() -> void:
	super.apply()
	var player:PlayerController = IngameDataManager.gameplay_manager.player_controller
	var current_atk := player.stat.get_final(StatController.StatType.ATTACK)
	current_atk -= 2
	player.stat.set_final(StatController.StatType.ATTACK, current_atk)
	(IngameDataManager.text_manager as TextManager).show_text("-2 Atk", player.player_pivot.global_position, Color.RED)	
	AudioManager.play_sfx(SfxContainer.SfxID.NEGATIVE_MODIFIER)
	EventBus.on_recalculate_player_stat.emit()
