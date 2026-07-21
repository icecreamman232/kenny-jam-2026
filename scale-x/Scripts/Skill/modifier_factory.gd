extends Node

func create_modifier(modifier_id:Modifier.ModifierId) ->Modifier:
	match modifier_id:
		Modifier.ModifierId.MultiHand: return MultiHandModifier.new()
		Modifier.ModifierId.LeftSwing: return LeftSwingModifier.new()
		Modifier.ModifierId.RightSwing: return RightSwingModifier.new()
		Modifier.ModifierId.LoneWolf: return LoneWolfModifier.new()
		Modifier.ModifierId.ContinuesAttack: return ContinuesAttackModifier.new()
		_: return null
	
