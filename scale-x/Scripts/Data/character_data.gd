class_name CharacterData extends Resource

enum CharacterID
{
	Knight,
	King,
	Rogue,
	Executioner
}

@export var character_id:CharacterID
@export var character_name:String
@export var character_avatar:Texture2D
@export_group("Stat")
@export var attack:int
@export var accuracy:int
@export var speed:int
@export var life:int
@export var dodge:int
@export var armor:int
@export_group("Mod")
@export var skill_display_name:String
@export_multiline var skill_desc:String
@export var skill_name:String