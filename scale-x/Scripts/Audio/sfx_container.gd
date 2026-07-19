class_name SfxContainer extends Node

enum SfxID
{
	UI_BUTTON_CLICK,
	POSITIVE_MODIFIER,
	NEGATIVE_MODIFIER,
	SWORD_HIT_1,
	SWORD_HIT_2,
}

@export var sfx_list:Dictionary[SfxID, AudioStream] = {}


