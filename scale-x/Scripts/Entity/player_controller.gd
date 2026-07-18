class_name PlayerController extends EntityController

@export var stat:PlayerStatController
@export var avatar:PlayerAvatar
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
	life = 3
	health.initialize_health(3)
	stat.initialize()
	for idx in range(0, 9):
		item_list.append(null)


func _exit_tree() -> void:
	EventBus.on_add_item.disconnect(_add_item)


func play_attack_tween():
	var tween :Tween= avatar.attack_tween()
	await tween.finished
	
	
func deal_damage_to_enemy(enemy_controller: EnemyController):
	enemy_controller.health.take_damage(attack)


func _add_item(index:int, item:ItemData):
	item_list[index] = item
	_update_stats(item_list[index])
	health.update_life(life)


func _reset_stats():
	attack = 0
	speed = 0
	life = 0
	mana = 0
	dodge = 0
	armor = 0
	
	
func _update_stats(item:ItemData):
	attack += item.attack
	speed += item.speed
	life += item.life
	mana += item.mana
	dodge += item.dodge
	armor += item.armor	
		
