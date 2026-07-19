class_name SfxContainer extends Node

enum SfxID
{
	UI_BUTTON_CLICK,
	POSITIVE_MODIFIER,
	NEGATIVE_MODIFIER,
}

@export var sfx_list:Dictionary[SfxID, AudioStream] = {}


