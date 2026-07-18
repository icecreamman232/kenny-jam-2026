class_name ItemInfoUi extends Control

@export var item_name:Label
@export var atk_label:Label
@export var speed_label:Label
@export var life_label:Label
@export var mana_label:Label
@export var dodge_label:Label
@export var armor_label:Label

func _ready():
	item_name.hide()
	hide()
	EventBus.on_hover_on_item.connect(_update_item_stat)
	
	
func _exit_tree() -> void:
	EventBus.on_hover_on_item.disconnect(_update_item_stat)


func _update_item_stat(item_data:ItemData) -> void:
	if item_data == null:
		item_name.hide()
		hide() 
		return
	atk_label.text = str(item_data.attack)
	speed_label.text = str(item_data.speed)
	life_label.text = str(item_data.life)
	mana_label.text = str(item_data.mana)
	dodge_label.text = str(item_data.dodge)
	armor_label.text = str(item_data.armor)
	item_name.text = item_data.item_name
	item_name.show()
	show()