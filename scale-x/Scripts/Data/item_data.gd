class_name ItemData extends Resource

enum ItemCategory
{
	HEAD_ARMOR,
	BODY_ARMOR,
	LEGS_ARMOR,
	BOW,
	CROSSBOW,
	SWORD,
	DAGGER
}

enum ItemRarity
{
	COMMON,
	UNCOMMON,
	RARE,
	LEGENDARY,
	EPIC
}

@export_group("Basic Settings")
@export var category:ItemCategory
@export var rarity:ItemRarity = ItemRarity.COMMON
@export var item_name:String
@export var item_icon:Texture2D
@export_group("Stats")
@export var stats:Array[StatController.StatType]
@export var attack:int
@export var accuracy:int
@export var speed:int
@export var life:int
@export var mana:int
@export var dodge:int
@export var armor:int


