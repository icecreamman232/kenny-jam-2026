class_name RegenerationEnemySkill extends EnemySkill

func get_skill_name() ->String: return "Regeneration"

func get_skill_description() ->String: return "Recover 1 life every round"

func trigger() -> void:
	if _enemy_controller.health.current_life <=0 : return
	_enemy_controller.health.recover_life(1)
	(IngameDataManager.text_manager as TextManager).show_text("+1 Life", _enemy_controller.enemy_pivot.global_position)	
	AudioManager.play_sfx(SfxContainer.SfxID.POSITIVE_MODIFIER)
	