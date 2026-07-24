class_name EnemySkill extends RefCounted


enum EnemySkillID
{
	NONE,
	REGENERATION,
	SACRIFICE,
	SUICIDE,
	THIEF,
	CHICKEN_ATTACK,
	FEAR,
	FAIR_FIGHT,
	SHY,
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
	
	
func get_skill_name() ->String: return ""

func get_skill_description() ->String: return ""	

func get_whole_mod_desc() ->String:
	return "[font_size=32][color=yellow]" + get_skill_name() +"[/color][/font_size][br]" + get_skill_description()



func apply() -> void: pass

func trigger() -> void: pass

func remove() -> void: pass
