class_name EnemySkill extends RefCounted


enum EnemySkillID
{
	NONE,
	REGENERATION,
	EMPOWER,
	SACRIFICE,
}

static func to_enemy_skill_id(skill_id: String) -> EnemySkillID:
	skill_id = skill_id.replace("-", "_").to_upper()
	var keys := EnemySkillID.keys()
	var idx := keys.find(skill_id)
	if idx == -1:
		push_error("Unknown enemy skill id: %s" % skill_id)
		return EnemySkillID.NONE
	return idx as EnemySkillID

var _enemy_controller:EnemyController

func _init(enemy_controller: EnemyController):
	_enemy_controller = enemy_controller
	
	
func get_modifier_name() ->String: return ""

func get_modifier_description() ->String: return ""	



func apply() -> void: pass

func trigger() -> void: pass

func remove() -> void: pass
