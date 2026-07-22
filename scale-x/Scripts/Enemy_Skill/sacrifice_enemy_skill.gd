class_name SacrificeEnemySkill extends EnemySkill


func get_skill_name() ->String: return "Sacrifice"

func get_skill_description() ->String: return "Spent 2 life to gain 1 damage"


func trigger() -> void:
	if _enemy_controller.health.current_life <=0 : return
	_enemy_controller.health.spent_life(2)
	(IngameDataManager.text_manager as TextManager).show_text("-2 Life", _enemy_controller.enemy_pivot.global_position, Color.RED)	
	AudioManager.play_sfx(SfxContainer.SfxID.NEGATIVE_MODIFIER)
	
	await Helper.wait_for_seconds(0.1)
	
	var current_atk := _enemy_controller.stat.get_final(StatController.StatType.ATTACK)
	current_atk += 1
	_enemy_controller.stat.set_final(StatController.StatType.ATTACK, current_atk)
	EventBus.update_enemy_info.emit(_enemy_controller.stat)
	(IngameDataManager.text_manager as TextManager).show_text("+1 Damage", _enemy_controller.enemy_pivot.global_position)
	AudioManager.play_sfx(SfxContainer.SfxID.POSITIVE_MODIFIER)
		