class_name PlayerController extends EntityController

@export var stat:PlayerStatController
@export var avatar:PlayerAvatar
@export var player_pivot:Control
@export_group("Stats")
@export var attack:int
@export var accuracy:int
@export var speed:int
@export var life:int
@export var mana:int
@export var dodge:int
@export var armor:int

@export var health:PlayerHealth
@export var item_list:Array[ItemData]

func initialize():
	EventBus.on_add_item.connect(_add_item)
	EventBus.on_remove_item.connect(_remove_item)
	_initialize_stat_from_character_data(IngameDataManager.selected_character_data)
	avatar.set_avatar(IngameDataManager.selected_character_data.character_avatar)
	stat.initialize()
	health.initialize_health(self)
	EventBus.update_player_info.emit(stat)
	for idx in range(0, 9):
		item_list.append(null)


func reset_player():
	stat.initialize()
	health.initialize_health(self)
	EventBus.update_player_info.emit(stat)
	for idx in range(0, 9):
		item_list.append(null)		


func _exit_tree() -> void:
	EventBus.on_add_item.disconnect(_add_item)


func add_damage(amount:int):
	attack += amount
	var current_attack := stat.get_final(StatController.StatType.ATTACK)
	current_attack += amount
	stat.set_final(StatController.StatType.ATTACK, current_attack)
	EventBus.update_player_info.emit(stat)


func add_max_health(amount:int) -> void:
	life += amount
	health.add_max_health(2)
	EventBus.update_player_info.emit(stat)
	

func play_attack_tween():
	var tween :Tween= avatar.attack_tween()
	await tween.finished
	
	
func deal_damage_to_enemy(enemy_controller: EnemyController) -> void:
	var player_acc := stat.get_final(StatController.StatType.ACCURACY)
	var rolled_acc := randi_range(0, player_acc)
	

	var is_guarantee_hit:bool = randf_range(0, 100) <= 10
	if not is_guarantee_hit:	
		var enemy_dodge:= enemy_controller.stat.get_final(StatController.StatType.DODGE)
		var rolled_enemy_dodge:= randi_range(0, enemy_dodge)
		if rolled_enemy_dodge > rolled_acc:
			(IngameDataManager.text_manager as TextManager).show_text("Miss", player_pivot.global_position, Color(0.5294118, 0.5294118, 0.5294118))
			EventBus.on_player_miss_attack.emit()
			await Helper.wait_for_frames(1)
			return
	enemy_controller.health.take_damage(stat.get_final(StatController.StatType.ATTACK))


func on_before_dead():
	pass


func _initialize_stat_from_character_data(character_data:CharacterData):
	attack = character_data.attack
	accuracy = character_data.accuracy
	speed = character_data.speed
	life = character_data.life
	dodge = character_data.dodge
	armor = character_data.armor


func _add_item(index:int, item:ItemData):
	item_list[index] = item
	_add_stat_from_item(item)
	health.update_life(stat.get_final(StatController.StatType.LIFE))
	EventBus.update_player_info.emit(stat)


func _remove_item(index:int):
	var to_be_removed_item := item_list[index]
	_remove_stat_from_item(to_be_removed_item)
	health.update_life(stat.get_final(StatController.StatType.LIFE))
	EventBus.update_player_info.emit(stat)	
	item_list[index] = null
	
	
func _add_stat_from_item(item:ItemData):
	var new_attack := stat.get_final(StatController.StatType.ATTACK)
	var new_accuracy := stat.get_final(StatController.StatType.ACCURACY)
	var new_speed := stat.get_final(StatController.StatType.SPEED)
	var new_life := stat.get_final(StatController.StatType.LIFE)
	var new_mana := stat.get_final(StatController.StatType.MANA)
	var new_dodge := stat.get_final(StatController.StatType.DODGE)
	var new_armor := stat.get_final(StatController.StatType.ARMOR)
	
	new_attack += item.attack
	new_accuracy += item.accuracy
	new_speed += item.speed
	new_life += item.life
	new_mana += item.mana
	new_dodge += item.dodge
	new_armor += item.armor
	
	stat.set_final(StatController.StatType.ATTACK, new_attack)
	stat.set_final(StatController.StatType.ACCURACY, new_attack)
	stat.set_final(StatController.StatType.SPEED, new_speed)
	stat.set_final(StatController.StatType.LIFE, new_life)
	stat.set_final(StatController.StatType.MANA, new_mana)
	stat.set_final(StatController.StatType.DODGE, new_dodge)	
	stat.set_final(StatController.StatType.ARMOR, new_armor)	
	
	
func _remove_stat_from_item(item:ItemData) -> void:
	if item == null: return
	var new_attack := stat.get_final(StatController.StatType.ATTACK)
	var new_accuracy := stat.get_final(StatController.StatType.ACCURACY)
	var new_speed := stat.get_final(StatController.StatType.SPEED)
	var new_life := stat.get_final(StatController.StatType.LIFE)
	var new_mana := stat.get_final(StatController.StatType.MANA)
	var new_dodge := stat.get_final(StatController.StatType.DODGE)
	var new_armor := stat.get_final(StatController.StatType.ARMOR)	
	
	new_attack -= item.attack
	new_accuracy -= item.accuracy
	new_speed -= item.speed
	new_life -= item.life
	new_mana -= item.mana
	new_dodge -= item.dodge
	new_armor -= item.armor
	
	stat.set_final(StatController.StatType.ATTACK, new_attack)
	stat.set_final(StatController.StatType.ACCURACY, new_attack)
	stat.set_final(StatController.StatType.SPEED, new_speed)
	stat.set_final(StatController.StatType.LIFE, new_life)
	stat.set_final(StatController.StatType.MANA, new_mana)
	stat.set_final(StatController.StatType.DODGE, new_dodge)	
	stat.set_final(StatController.StatType.ARMOR, new_armor)		
