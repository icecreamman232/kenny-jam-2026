class_name EnemyController extends EntityController

@export var stat:EnemyStatController
@export var enemy_data:EnemyData
@export var avatar:EnemyAvatar
@export var health:EnemyHealth

func initialize(data: EnemyData):
	enemy_data = data
	stat.initialize()
	health.initialize_health(self)
	avatar.assign(data)
	avatar.show_icon()
	EventBus.update_enemy_info.emit(stat)


func play_attack_tween():
	var tween :Tween= avatar.attack_tween()
	await tween.finished	
	
	
func deal_damage_to_player(player_controller: PlayerController):
	player_controller.health.take_damage(enemy_data.attack)
