class_name HealerModifier extends Modifier


func _init():
	_mod_id = ModifierId.Healer

func get_modifier_name() ->String: return "Healer"

func get_modifier_description() -> String:
	return "Have 35% chance to heal 1 life each turn"
	
	
func apply(cell:PlayerCellGridUi):
	super.apply(cell)
	_owner_cell.assigned_item.attack = 0
	_owner_cell.assigned_item.accuracy = 0
	_owner_cell.assigned_item.speed = 0
	_owner_cell.assigned_item.life = 0
	#_owner_cell.assigned_item.mana = 0
	_owner_cell.assigned_item.dodge = 0
	_owner_cell.assigned_item.armor = 0
	EventBus.on_recalculate_player_stat.emit()
	
	
func trigger() -> void:
	super.trigger()
	var can_heal:bool = randi_range(0, 100) <= 35
	if not can_heal:return
	var player:PlayerController = IngameDataManager.gameplay_manager.player_controller
	player.health.recover_life(1)