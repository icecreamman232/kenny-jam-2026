extends Node

func create_skill(enemy_skill_id:String, enemy_controller:EnemyController) ->EnemySkill:
	var skill_id:EnemySkill.EnemySkillID = EnemySkill.to_enemy_skill_id(enemy_skill_id)
	match skill_id:
		EnemySkill.EnemySkillID.REGENERATION:
			return RegenerationEnemySkill.new(enemy_controller)
#		EnemySkill.EnemySkillID.EMPOWER:
#			pass
#		EnemySkill.EnemySkillID.SACRIFICE:
#			pass	
		_: return null
	
