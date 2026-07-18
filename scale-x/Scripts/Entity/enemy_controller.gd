class_name EnemyController extends EntityController

@export var avatar:EnemyAvatar
@export var health:EnemyHealth

func initialize(enemy_data: EnemyData):
	health.initialize_health(enemy_data.life)
	avatar.assign(enemy_data)

