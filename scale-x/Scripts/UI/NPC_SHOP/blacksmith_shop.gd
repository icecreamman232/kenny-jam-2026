class_name BlacksmithShop extends Control

@export var close_button:Button
@export var player_coin_label:RichTextLabel
@export var fix_price_label:RichTextLabel
@export var shop_slots:Array[BlacksmithShopSlot]

const FIX_PRICE:int = 12


func _ready():
	close_button.pressed.connect(_on_close_button_pressed)
	EventBus.on_open_npc_shop.connect(_on_open_npc_shop)
	fix_price_label.text = "Fix durability for only " + str(FIX_PRICE) + "[img=32 align=center,center]uid://de3k1fl4j5llo[/img]"
	
	
func _exit_tree() -> void:
	close_button.pressed.disconnect(_on_close_button_pressed)
	EventBus.on_open_npc_shop.disconnect(_on_open_npc_shop)
	
	
func _on_close_button_pressed():
	AudioManager.play_sfx(SfxContainer.SfxID.UI_BUTTON_CLICK)
	for slot in shop_slots:
		slot.reset_slot()
	await Helper.wait_for_frames(2)
	hide()
	IngameDataManager.gameplay_manager.force_spawn_enemy_or_boss()
	
	
func _on_open_npc_shop(npc_id:NpcManager.NpcID) -> void:
	if npc_id != NpcManager.NpcID.BLACKSMITH: return
	
	player_coin_label.text = "[img=32 align=center,center]uid://de3k1fl4j5llo[/img]" + str(IngameDataManager.coin_hud.current_coin)
	var player_grid:PlayerGridUi = IngameDataManager.player_grid
	for idx in range(player_grid.cell_grid.size()):
		shop_slots[idx].assign_slot(player_grid.cell_grid[idx])
	show()
	
	
func request_to_fix_slot(cell:PlayerCellGridUi, slot:BlacksmithShopSlot) -> void:
	if cell == null or cell.assigned_item == null: return
	
	if IngameDataManager.coin_hud.current_coin < FIX_PRICE: return
	
	EventBus.on_coin_change.emit(-FIX_PRICE)
	cell.assigned_item.durability += 1
	slot.update_slot_visual()
	AudioManager.play_sfx(SfxContainer.SfxID.POSITIVE_MODIFIER)
	await slot.play_bounce_tween()
	cell.update_durability_visual()
	player_coin_label.text = "[img=32 align=center,center]uid://de3k1fl4j5llo[/img]" + str(IngameDataManager.coin_hud.current_coin)
	
	
