class_name ItemInfoUi extends Control

@export var item_name:Label
@export var atk_label:Label
@export var acc_label:Label
@export var speed_label:Label
@export var life_label:Label
@export var mana_label:Label
@export var dodge_label:Label
@export var armor_label:Label
@export var price_label:Label
@export var mod_parent:Control
@export var mod_1_desc:RichTextLabel
@export var mod_2_desc:RichTextLabel

func _ready():
	item_name.hide()
	mod_parent.hide()
	mod_1_desc.hide()
	mod_2_desc.hide()
	hide()
	EventBus.on_hover_on_item.connect(_update_item_stat)
	
	
func _exit_tree() -> void:
	EventBus.on_hover_on_item.disconnect(_update_item_stat)


func _update_item_stat(item_data:ItemData) -> void:
	if item_data == null:
		mod_parent.hide()
		item_name.hide()
		hide() 
		return
	atk_label.text = str(item_data.attack)
	acc_label.text = str(item_data.accuracy)
	speed_label.text = str(item_data.speed)
	life_label.text = str(item_data.life)
	mana_label.text = str(item_data.mana)
	dodge_label.text = str(item_data.dodge)
	armor_label.text = str(item_data.armor)
	price_label.text = str(ItemData.get_price_for_item(item_data))
	item_name.text = item_data.item_name
	
	mod_parent.hide()
	mod_1_desc.hide()
	mod_2_desc.hide()
	
	if item_data.modifier_list.size() == 1:
		mod_1_desc.text = item_data.modifier_list[0].get_whole_mod_desc()
		mod_1_desc.show()
		mod_2_desc.hide()
		mod_parent.show()
	elif item_data.modifier_list.size() == 2:
		mod_1_desc.text = item_data.modifier_list[0].get_whole_mod_desc()
		mod_2_desc.text = item_data.modifier_list[1].get_whole_mod_desc()
		mod_1_desc.show()
		mod_2_desc.show()
		mod_parent.show()
	
	item_name.show()
	show()
