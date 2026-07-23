class_name EnemyData extends Resource

@export var enemy_name:String
@export var enemy_icon:Texture2D
@export var is_boss:bool = false
@export_group("Stats")
@export var attack:int
@export var accuracy:int
@export var speed:int
@export var life:int
@export var mana:int
@export var dodge:int
@export var armor:int
@export_group("Skill Pool")
@export var skill_pool:Array[String]