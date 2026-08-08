class_name ItemInfoUi extends Control

@export var item_name:RichTextLabel
@export var dur_label:Label
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

const BLOCK_CELL_MESSAGE:String = "[font_size=32][color=gray]Blocked Slot[/color][/font_size][br]The slot will be blocked from either placing or move the item. The item will be still working"


func _ready():
	item_name.hide()
	mod_parent.hide()
	mod_1_desc.hide()
	mod_2_desc.hide()
	hide()
	EventBus.on_hover_on_item.connect(_update_item_stat)
	
	
func _exit_tree() -> void:
	EventBus.on_hover_on_item.disconnect(_update_item_stat)


func _update_item_stat(item_data:ItemData, slot_index:int) -> void:
	var player_grid:PlayerGridUi = IngameDataManager.player_grid
	var is_blocked:bool
	if slot_index != -1:
		is_blocked = player_grid.cell_grid[slot_index].is_blocked
	else:
		is_blocked = false
	

	if item_data == null:
		if is_blocked:
			item_name.text = "Blocked Slot"
			item_name.show()
			mod_1_desc.text = BLOCK_CELL_MESSAGE
			mod_1_desc.show()
			mod_parent.show()
			
			dur_label.text = str(0)	
			atk_label.text = str(0)	
			acc_label.text = str(0)	
			speed_label.text = str(0)	
			life_label.text = str(0)	
			mana_label.text = str(0)	
			dodge_label.text = str(0)	
			armor_label.text = str(0)	
			price_label.text = str(0)	
			
			show()
		else:
			mod_parent.hide()
			item_name.hide()
			hide() 
		return
	
	
			
		
	dur_label.text = str(item_data.durability)	
	atk_label.text = str(item_data.attack)
	acc_label.text = str(item_data.accuracy)
	speed_label.text = str(item_data.speed)
	life_label.text = str(item_data.life)
	mana_label.text = str(item_data.mana)
	dodge_label.text = str(item_data.dodge)
	armor_label.text = str(item_data.armor)
	price_label.text = str(ItemData.get_price_for_item(item_data))
	
	var rarity_color:Color = Helper.get_color_by_rarity(item_data.rarity)
	if item_data.rarity == ItemData.ItemRarity.COMMON:
		rarity_color = Color(1.0, 0.914, 0.769)
	var color_html := rarity_color.to_html(false)
	var item_name_text:String = "[color=#" + color_html + "]" + item_data.item_name + "[/color]"

	item_name.text = item_name_text
	
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
	
	if is_blocked:
		item_name.text = _get_item_name_blocked(item_name_text)
		mod_2_desc.text = mod_1_desc.text
		mod_1_desc.text = BLOCK_CELL_MESSAGE
		mod_2_desc.show()
		mod_2_desc.show()
		mod_parent.show()
	
	
	item_name.show()
	show()


func _get_item_name_blocked(item_name_input:String) -> String:
	return "[color=gray]Blocked [/color]" + item_name_input

		