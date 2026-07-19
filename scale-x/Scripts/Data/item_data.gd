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
var attack:int
var accuracy:int
var speed:int
var life:int
var mana:int
var dodge:int
var armor:int
@export_group("Modifier Pool")
@export var modifier_pool:Array[Modifier.ModifierId]
var modifier_list:Array[Modifier]


static func get_price_for_item(item:ItemData) -> int:
	match item.rarity:
		ItemRarity.COMMON:
			return 1
		ItemRarity.UNCOMMON:
			return 2
		ItemRarity.RARE:
			return 4
		ItemRarity.LEGENDARY:
			return 6
		ItemRarity.EPIC:
			return 12
		_: return 0


static func is_weapon(item:ItemData) -> bool:
	if item.category == ItemCategory.BOW \
	or item.category == ItemCategory.CROSSBOW \
	or item.category == ItemCategory.SWORD \
	or item.category == ItemCategory.DAGGER:
		return true
	return false

