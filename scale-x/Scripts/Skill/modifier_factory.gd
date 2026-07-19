extends Node

func create_modifier(modifier_id:Modifier.ModifierId) ->Modifier:
	match modifier_id:
		Modifier.ModifierId.MultiHand: return MultiHandModifier.new()
		_: return null
	
