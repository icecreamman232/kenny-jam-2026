class_name LootBoxCellUi extends TextureRect

@export var assigned_item:ItemData
@export var price_label:RichTextLabel
@export var assigned_item_icon:TextureRect


func handle_drag(is_dragging:bool):
	assigned_item_icon.visible = !is_dragging


func assign_item(item:ItemData):
	assigned_item = item
	assigned_item_icon.texture = item.item_icon
	assigned_item_icon.self_modulate = Helper.get_color_by_rarity(item.rarity)
	price_label.show()	
	price_label.text = "[img=24]uid://de3k1fl4j5llo[/img]" + str(ItemData.get_price_for_item(item)).pad_decimals(0)
	
func unassign_item():
	price_label.hide()
	assigned_item = null
	assigned_item_icon.texture = null
