class_name NpcManager extends Node

const ROUND_THAT_HAS_NPC:Array[int] = [11, 16, 24]

enum NpcID
{
	STAT_MASTER,
}


func can_spawn_npc(round_number:int) -> bool:
	if not ROUND_THAT_HAS_NPC.has(round_number): return false	
	return true
	
	
func spawn_npc():
	var random_npc_id:NpcID= NpcManager.NpcID.values().pick_random()
	EventBus.on_open_npc_shop.emit(random_npc_id)

	
	