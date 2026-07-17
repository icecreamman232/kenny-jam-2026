class_name PlayerController extends EntityController

@export_group("Stats")
@export var attack:int
@export var speed:int
@export var life:int
@export var mana:int
@export var dodge:int
@export var armor:int

@export var health:PlayerHealth
@export var item_list:Array[ItemData]

func initialize():
	EventBus.on_add_item.connect(_add_item)
	health.initialize_health(10)
	for idx in range(0, 9):
		item_list.append(null)


func _exit_tree() -> void:
	EventBus.on_add_item.disconnect(_add_item)


func _add_item(index:int, item:ItemData):
	item_list[index] = item
	_update_stats()


func _reset_stats():
	attack = 0
	speed = 0
	life = 0
	mana = 0
	dodge = 0
	armor = 0
	
	
func _update_stats():
	_reset_stats()
	for idx in range(item_list.size()):
		if item_list[idx] == null: continue
		attack += item_list[idx].attack
		speed += item_list[idx].speed
		life += item_list[idx].life
		mana += item_list[idx].mana
		dodge += item_list[idx].dodge
		armor += item_list[idx].armor
		
		