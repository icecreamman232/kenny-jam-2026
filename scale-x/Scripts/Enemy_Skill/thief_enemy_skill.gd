class_name ThiefEnemySkill extends EnemySkill

func get_skill_name() ->String: return "Thief"

func get_skill_description() ->String: return "Steal random 2-8 coins"


func apply() -> void:
	super.apply()
	EventBus.on_coin_change.emit(randi_range(2, 8) * -1)
	(IngameDataManager.text_manager as TextManager).show_text("Stolen", _enemy_controller.enemy_pivot.global_position, Color.YELLOW)
	AudioManager.play_sfx(SfxContainer.SfxID.NEGATIVE_MODIFIER)