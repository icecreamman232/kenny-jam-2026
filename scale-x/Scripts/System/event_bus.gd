extends Node

# Player Events
signal on_player_update_life(current_life:int, max_life:int)
signal on_add_item(index:int, item:ItemData)
signal on_remove_item(index:int)

# Enemy Events
signal update_enemy_info(enemy_stat_controller: EnemyStatController)
signal on_enemy_update_life(current_life:int, max_life:int)
signal on_enemy_dead


# Gameplay Events
signal on_hover_on_item(item:ItemData)
signal on_fight_started
signal on_fight_end
signal update_player_info(player_stat_controller: PlayerStatController)