class_name PlayerSkill extends RefCounted

enum SkillID
{
	NONE,
	LOYALTY,
	WEALTHY,
	QUICK_STEP,
	BRUTAL,
}

	
static func parser_string_to_skill_id(skill_id:String) ->SkillID:
	skill_id = skill_id.replace("-", "_").to_upper()
	var keys := SkillID.keys()
	var idx := keys.find(skill_id)
	if idx == -1:
		push_error("Unknown enemy skill id: %s" % skill_id)
		return SkillID.NONE
	return idx as SkillID	
	
func get_skill_name() ->String: return ""

func get_skill_desc() ->String: return ""

func get_whole_desc() ->String: return ""


func apply(): pass

func trigger(): pass

func remove(): pass

func reset(): pass
	
