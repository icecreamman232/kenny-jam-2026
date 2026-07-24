class_name ShyEnemySkill extends EnemySkill

var _has_applied:bool = false

func get_skill_name() ->String: return "Shy"

func get_skill_description() ->String: return "If player check enemy skill, it feel shy and increase its armor by 5. Trigger once"

func apply() -> void:
	super.apply()
	EventBus.on_player_check_enemy_skill.connect(_on_player_check_enemy_skill)

func remove() -> void:
	EventBus.on_player_check_enemy_skill.disconnect(_on_player_check_enemy_skill)
	
	
func _on_player_check_enemy_skill() -> void:
	if _has_applied: return
	
	var current_armor := _enemy_controller.stat.get_final(StatController.StatType.ARMOR)
	var new_armor := current_armor + 5
	_enemy_controller.stat.set_final(StatController.StatType.ARMOR, new_armor)
	EventBus.update_enemy_info.emit(_enemy_controller.stat)
	
	
	
	_has_applied = true