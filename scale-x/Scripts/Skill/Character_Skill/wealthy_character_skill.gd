class_name WealthyCharacterSkill extends PlayerSkill

func get_skill_name() -> String: return "Wealthy"

func get_skill_description() -> String: return "Starts game with 10 coins"


func apply() -> void: 
	super.apply()
	IngameDataManager.gameplay_manager.coin_hud.current_coin = 10
	IngameDataManager.gameplay_manager.coin_hud.force_update_visual()
	