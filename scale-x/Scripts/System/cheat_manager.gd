class_name CheatManager extends Control

@export var is_immortal_check_button:CheckButton
@export var always_execute_check_button:CheckButton
@export var load_chicken_boss_button:Button
@export var open_stat_master_shop_button:Button
@export var open_blacksmith_shop_button:Button
@export var add_coin_button:Button
@export_group("Character Unlock")
@export var unlock_character_button:Button
@export var character_unlock_option_panel:Control


var is_immortal:bool = false
var is_always_execute:bool = false
var has_popup_open:bool = false

func _ready():
	InputManager.on_show_cheat_menu.connect(_show_menu)
	InputManager.on_hide_cheat_menu.connect(_hide_menu)
	load_chicken_boss_button.pressed.connect(_load_chicken_boss)
	IngameDataManager.cheat_manager = self
	is_immortal_check_button.toggled.connect(_is_immortal_check_button_toggled)
	always_execute_check_button.toggled.connect(_always_execute_check_button_toggled)
	open_stat_master_shop_button.pressed.connect(_open_stat_master_shop)
	open_blacksmith_shop_button.pressed.connect(_open_blacksmith_shop)
	add_coin_button.pressed.connect(_on_add_coin_button_pressed)
	
	unlock_character_button.pressed.connect(_on_unlock_character_button_pressed)
	
	
func _exit_tree() -> void:
	InputManager.on_show_cheat_menu.disconnect(_show_menu)
	InputManager.on_hide_cheat_menu.disconnect(_hide_menu)
	load_chicken_boss_button.pressed.disconnect(_load_chicken_boss)
	is_immortal_check_button.toggled.disconnect(_is_immortal_check_button_toggled)
	always_execute_check_button.toggled.disconnect(_always_execute_check_button_toggled)
	open_stat_master_shop_button.pressed.disconnect(_open_stat_master_shop)
	open_blacksmith_shop_button.pressed.disconnect(_open_blacksmith_shop)
	add_coin_button.pressed.disconnect(_on_add_coin_button_pressed)
	unlock_character_button.pressed.disconnect(_on_unlock_character_button_pressed)


func _show_menu() -> void:
	if OS.has_feature("public"): return
	show()
	
	
func _hide_menu() -> void:
	if has_popup_open: return
	hide()
		
	
func _is_immortal_check_button_toggled(is_toggled:bool):
	is_immortal = is_toggled
	

func _always_execute_check_button_toggled(is_toggled:bool):
	is_always_execute = is_toggled
	
	
func _load_chicken_boss() -> void:
	if has_popup_open: return
	var gameplay_manager := IngameDataManager.gameplay_manager as GameplayManager
	gameplay_manager.round_number = GameplayManager.MAX_ROUND
	gameplay_manager.enemy_controller.health.take_damage(1000000000)
	
	
func _open_stat_master_shop() -> void:
	if has_popup_open: return
	EventBus.on_open_npc_shop.emit(NpcManager.NpcID.STAT_MASTER)
	
	
func _open_blacksmith_shop() -> void:
	if has_popup_open: return
	EventBus.on_open_npc_shop.emit(NpcManager.NpcID.BLACKSMITH)
	
	
func _on_add_coin_button_pressed() -> void:
	if has_popup_open: return
	EventBus.on_coin_change.emit(100)
	
	
func _on_unlock_character_button_pressed() -> void:
	if has_popup_open: return
	character_unlock_option_panel.show()
	has_popup_open = true
	
