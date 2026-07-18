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
	health.initialize_health(life)
	stat.initialize()
	EventBus.update_player_info.emit(stat)
	for idx in range(0, 9):
		item_list.append(null)


func _exit_tree() -> void:
	EventBus.on_add_item.disconnect(_add_item)


func play_attack_tween():
	var tween :Tween= avatar.attack_tween()
	await tween.finished
	
	
func deal_damage_to_enemy(enemy_controller: EnemyController):
	enemy_controller.health.take_damage(
		stat.get_base(StatController.StatType.ATTACK) 
		+ stat.get_final(StatController.StatType.ATTACK))


func _add_item(index:int, item:ItemData):
	item_list[index] = item
	_update_stats()
	health.update_life(
		stat.get_base(StatController.StatType.LIFE)
		+ stat.get_final(StatController.StatType.LIFE))
	EventBus.update_player_info.emit(stat)


func _reset_stats():
	attack = 0
	speed = 0
	life = 0
	mana = 0
	dodge = 0
	armor = 0
	
	
func _update_stats():
	var new_attack := 0
	var new_speed := 0
	var new_life := 0
	var new_mana := 0
	var new_dodge := 0
	var new_armor := 0
	
	for idx in range(item_list.size()):
		var item:= item_list[idx]
		if item == null: continue
		new_attack += item.attack
		new_speed += item.speed
		new_life += item.life
		new_mana += item.mana
		new_dodge += item.dodge
		new_armor += item.armor	
		
	stat.set_final(StatController.StatType.ATTACK, new_attack)
	stat.set_final(StatController.StatType.SPEED, new_speed)
	stat.set_final(StatController.StatType.LIFE, new_life)
	stat.set_final(StatController.StatType.MANA, new_mana)
	stat.set_final(StatController.StatType.DODGE, new_dodge)	
	stat.set_final(StatController.StatType.ARMOR, new_armor)	
