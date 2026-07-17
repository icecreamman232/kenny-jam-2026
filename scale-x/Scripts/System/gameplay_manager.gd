class_name GameplayManager extends Node

@export var player_controller:PlayerController
@export var loot_box_ui:LootBoxUI

func _ready():
	player_controller.initialize()
	await Helper.wait_for_frames(3)
	loot_box_ui.show_loot()
