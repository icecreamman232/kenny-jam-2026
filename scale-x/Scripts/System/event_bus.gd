extends Node

# Player Events
signal on_player_update_life(current_life:int, max_life:int)
signal on_add_item(index:int, item:ItemData)
signal on_remove_item(index:int)
signal on_move_item(from_index:int, to_index:int)
signal on_recalculate_player_stat
signal on_player_miss_attack

# Enemy Events
signal update_enemy_info(enemy_stat_controller: EnemyStatController)
signal on_enemy_update_life(current_life:int, max_life:int)
signal on_enemy_attack
signal on_enemy_dead


# Gameplay Events
signal on_player_check_enemy_skill
signal on_apply_item(cindex:int, item:ItemData)
signal on_coin_change(amount:int)
signal on_hover_on_item(item:ItemData)
signal on_hover_on_enemy(enemy_controller:EnemyController)
signal on_mouse_exit_enemy()
signal on_fight_started
signal on_fight_end
signal on_player_dead
signal on_boss_appear
signal on_victory
signal update_player_info(player_stat_controller: PlayerStatController)
signal on_add_item_to_cell(index:int, item:ItemData)
signal on_remove_item_from_cell(index:int, item:ItemData)