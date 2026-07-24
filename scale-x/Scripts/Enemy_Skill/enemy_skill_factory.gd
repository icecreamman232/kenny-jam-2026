extends Node

func create_skill(enemy_skill_id:String, enemy_controller:EnemyController) ->EnemySkill:
	var skill_id:EnemySkill.EnemySkillID = EnemySkill.to_enemy_skill_id(enemy_skill_id)
	match skill_id:
		EnemySkill.EnemySkillID.REGENERATION:
			return RegenerationEnemySkill.new(enemy_controller)
		EnemySkill.EnemySkillID.SUICIDE:
			return SuicideEnemySkill.new(enemy_controller)
		EnemySkill.EnemySkillID.SACRIFICE:
			return SacrificeEnemySkill.new(enemy_controller)
		EnemySkill.EnemySkillID.THIEF:
			return ThiefEnemySkill.new(enemy_controller)
		EnemySkill.EnemySkillID.FEAR:
			return FearAttackEnemySkill.new(enemy_controller)
		EnemySkill.EnemySkillID.FAIR_FIGHT:
			return FairFightEnemySkill.new(enemy_controller)
		EnemySkill.EnemySkillID.SHY:
			return ShyEnemySkill.new(enemy_controller)						
		EnemySkill.EnemySkillID.CHICKEN_ATTACK:
			return ChickenAttackEnemySkill.new(enemy_controller)
			
		_: return null
	
