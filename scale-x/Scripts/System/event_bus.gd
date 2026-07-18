extends Node

# Player Events
signal on_player_update_life(current_life:int, max_life:int)
signal on_add_item(index:int, item:ItemData)

# Enemy Events
signal on_enemy_update_life(current_life:int, max_life:int)


# Gameplay Events
signal on_fight_started