class_name SfxContainer extends Node

enum SfxID
{
	UI_BUTTON_CLICK,
	POSITIVE_MODIFIER,
	NEGATIVE_MODIFIER,
	SWORD_HIT_1,
	SWORD_HIT_2,
	MONSTER_ATK_1,
	MONSTER_ATK_2,
	GAME_OVER,
}

@export var sfx_list:Dictionary[SfxID, AudioStream] = {}


