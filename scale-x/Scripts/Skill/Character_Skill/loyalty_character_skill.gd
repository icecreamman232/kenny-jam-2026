class_name LoyaltyCharacterSkill extends PlayerSkill

var _round_counter:int = 0

func get_skill_name() -> String: return "Loyalty"

func get_skill_description() -> String: return "+2 life every 5 rounds"

func apply() -> void: 
	super.apply()
	EventBus.on_new_round.connect(_on_new_round)
	
	
func remove() -> void:
	EventBus.on_new_round.disconnect(_on_new_round)


func _on_new_round():
	_round_counter += 1
	if _round_counter % 5 == 0:
		var player:PlayerController = IngameDataManager.gameplay_manager.player_controller
		player.health.add_max_health(2)
		_round_counter = 0