extends Node

func create_skill(string_id:String) ->PlayerSkill:
	var skill_id:PlayerSkill.SkillID = PlayerSkill.parser_string_to_skill_id(string_id)
	match skill_id:
		PlayerSkill.SkillID.LOYALTY: return LoyaltyCharacterSkill.new()
		PlayerSkill.SkillID.WEALTHY: return WealthyCharacterSkill.new()
		PlayerSkill.SkillID.QUICK_STEP: return QuickStepCharacterSkill.new()
		PlayerSkill.SkillID.BRUTAL: return null
		PlayerSkill.SkillID.NONE: return null
		_: return null