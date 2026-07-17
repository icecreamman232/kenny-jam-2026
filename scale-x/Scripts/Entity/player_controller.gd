class_name PlayerController extends EntityController

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