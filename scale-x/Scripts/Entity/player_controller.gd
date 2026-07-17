class_name PlayerController extends EntityController

@export var health:PlayerHealth

func initialize():
	health.initialize_health(10)
