class_name HexModifier extends Modifier

var _has_triggered:bool = false

func _init():
	_mod_id = ModifierId.Hex


func get_modifier_name() ->String: return "Hex"

func get_modifier_description() -> String:
	return "In fight, have 25% chance to turn enemy into a chicken. Their attack and armor set to 0. Trigger once"
	
func trigger() -> void:
	super.trigger()
	if _has_triggered: return
	var should_trigger:bool = randi_range(0, 100) <= 25
	if not should_trigger: return
	var enemy:EnemyController = IngameDataManager.gameplay_manager.enemy_controller
	if enemy.is_hex: return
	enemy.set_hex(true)
	_has_triggered = true
	
	
func remove() -> void:
	super.remove()
	var enemy:EnemyController = IngameDataManager.gameplay_manager.enemy_controller
	if _has_triggered and enemy.is_hex:
		enemy.set_hex(false)
