class_name ExplodeModifier extends Modifier

func _init():
	_mod_id = ModifierId.Explode


func get_modifier_name() ->String: return "Explode"

func get_modifier_description() -> String:
	return "Grant no stat and have 1 durability. On destroy, explode and cause 2 damage to enemy"
	
func apply(cell:PlayerCellGridUi):
	super.apply(cell)
	_owner_cell.assigned_item.durability = 1
	_owner_cell.assigned_item.attack = 0
	_owner_cell.assigned_item.accuracy = 0
	_owner_cell.assigned_item.speed = 0
	_owner_cell.assigned_item.life = 0
	#_owner_cell.assigned_item.mana = 0
	_owner_cell.assigned_item.dodge = 0
	_owner_cell.assigned_item.armor = 0
	EventBus.on_recalculate_player_stat.emit()
	
	
func remove() ->void:
	super.remove()
	var enemy:= IngameDataManager.gameplay_manager.enemy_controller as EnemyController
	if enemy.health.current_life <= 0: return
	enemy.health.take_damage(2)	
