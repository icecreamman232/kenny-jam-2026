class_name EnemySkillInfo extends Control

@export var skill_desc:RichTextLabel

func _ready():
	hide()
	EventBus.on_hover_on_enemy.connect(_on_hover_on_enemy)
	EventBus.on_mouse_exit_enemy.connect(hide)
	
func _exit_tree() -> void:
	EventBus.on_hover_on_enemy.disconnect(_on_hover_on_enemy)
	EventBus.on_mouse_exit_enemy.disconnect(hide)
	
	
func _on_hover_on_enemy(enemy:EnemyController) -> void:
	if enemy.skill_list.size() <=0 : return
	var currernt_skill:EnemySkill = enemy.skill_list[0]
	skill_desc.text = currernt_skill.get_whole_mod_desc()
	show()
