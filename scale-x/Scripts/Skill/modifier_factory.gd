extends Node

func create_modifier(modifier_id:Modifier.ModifierId) ->Modifier:
	match modifier_id:
		Modifier.ModifierId.MultiHand: return MultiHandModifier.new()
		Modifier.ModifierId.LeftSwing: return LeftSwingModifier.new()
		Modifier.ModifierId.RightSwing: return RightSwingModifier.new()
		Modifier.ModifierId.LoneWolf: return LoneWolfModifier.new()
		Modifier.ModifierId.ContinuesAttack: return ContinuesAttackModifier.new()
		Modifier.ModifierId.SpearHead: return SpearHeadModifier.new()
		Modifier.ModifierId.Eater: return EaterModifier.new()
		Modifier.ModifierId.DeathIsNotTheEnd: return DeathIsNotTheEndModifier.new()
		Modifier.ModifierId.SharpenTool: return SharpenToolModifier.new()
		Modifier.ModifierId.ThreeMusketeers: return ThreeMusketeersModifier.new()
		Modifier.ModifierId.TheTwin: return TheTwinModifier.new()
		
		# v0.0.5
		Modifier.ModifierId.OverPower: return OverPowerModifier.new()
		Modifier.ModifierId.Healer: return HealerModifier.new()
		Modifier.ModifierId.GoreCleave: return GoreCleaveModifier.new()
		
		# v0.0.6
		Modifier.ModifierId.SelfImprove: return SelfImproveModifier.new()
		
		
		_: return null
	
