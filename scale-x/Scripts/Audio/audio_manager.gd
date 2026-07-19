extends Node

var sfx_player:AudioStreamPlayer2D
var sfx_container:SfxContainer

func _ready():
	sfx_player = AudioStreamPlayer2D.new()
	sfx_player.autoplay = false
	add_child(sfx_player)
	await Helper.wait_for_frames(1)

	var sfx_container_scene:PackedScene = load("uid://dbrjvpj34mged")
	if sfx_container_scene == null:
		push_error("Failed to load SFX container scene") 
	else:
		sfx_container = sfx_container_scene.instantiate() as SfxContainer
		add_child(sfx_container)
		
		
func play_sfx(sfx_id:SfxContainer.SfxID) -> void:
	var stream:AudioStream = sfx_container.sfx_list.get(sfx_id, null)
	if stream == null: return
	sfx_player.stream = stream
	sfx_player.play()
	
