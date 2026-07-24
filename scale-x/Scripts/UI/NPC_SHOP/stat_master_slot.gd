class_name StatMasterSlot extends Control

@export var shop_ref:StatMasterShop
@export var background:TextureRect
@export var stat_icon:TextureRect
@export var stat_label:RichTextLabel
@export var stat_name:Label
@export var button:Button

var _stat_type:StatController.StatType = StatController.StatType.ATTACK
var _price:int = 0



const STAT_NAME_DICT:Dictionary[StatController.StatType,String] = {
	StatController.StatType.ATTACK: "ATK",
	StatController.StatType.ACCURACY: "ACC",
	StatController.StatType.SPEED: "SPD",
	StatController.StatType.LIFE: "LIFE",
	StatController.StatType.DODGE: "DODGE",
	StatController.StatType.ARMOR: "ARMOR",
}


func _ready():
	button.mouse_entered.connect(_on_mouse_entered)
	button.mouse_exited.connect(_on_mouse_exited)
	button.pressed.connect(_on_button_pressed)
	stat_name.hide()


func _exit_tree() -> void:
	button.mouse_entered.disconnect(_on_mouse_entered)
	button.mouse_exited.disconnect(_on_mouse_exited)
	button.pressed.disconnect(_on_button_pressed)	


func show_slot(icon:Texture2D, price:int, stat_type:StatController.StatType):
	stat_icon.texture = icon
	_price = price
	stat_label.text = str(price)
	stat_label.show()
	_stat_type = stat_type
	stat_name.text = STAT_NAME_DICT[stat_type]
	
	
func sold_out():
	stat_icon.texture = null
	_price = 0
	stat_label.text = ""
	stat_label.hide()
	

func _on_mouse_entered():
	background.self_modulate = Color(0.957, 0.706, 0.106)
	stat_name.show()
	
	
func _on_mouse_exited():
	background.self_modulate = Color(1.0, 0.914, 0.769)
	stat_name.hide()
	
	
func _on_button_pressed():
	AudioManager.play_sfx(SfxContainer.SfxID.UI_BUTTON_CLICK)
	shop_ref.request_to_buy_stat(_stat_type, _price, self)
