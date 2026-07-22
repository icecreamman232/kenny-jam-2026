extends Node

var sfx_player:AudioStreamPlayer2D
var bgm_player:AudioStreamPlayer2D
var sfx_container:SfxContainer
var bgm_container:BgmContainer

func _ready():
	sfx_player = AudioStreamPlayer2D.new()
	sfx_player.autoplay = false
	sfx_player.max_polyphony = 20
	
	bgm_player = AudioStreamPlayer2D.new()
	bgm_player.autoplay = false
	bgm_player.finished.connect(_on_music_stop)
	
	
	add_child(sfx_player)
	await Helper.wait_for_frames(1)
	
	add_child(bgm_player)
	await Helper.wait_for_frames(1)

	var sfx_container_scene:PackedScene = load("uid://dbrjvpj34mged")
	if sfx_container_scene == null:
		push_error("Failed to load SFX container scene") 
	else:
		sfx_container = sfx_container_scene.instantiate() as SfxContainer
		add_child(sfx_container)
	
	
	var bgm_container_scene:PackedScene = load("uid://mk7d8iikuc0c")
	if bgm_container_scene == null:
		push_error("Failed to load BGM container scene") 
	else:
		bgm_container = bgm_container_scene.instantiate() as BgmContainer
		add_child(bgm_container)	
		
func _exit_tree() -> void:
	bgm_player.finished.disconnect(_on_music_stop)
	

func play_music() -> void:
	if bgm_player ==  null: return
	if bgm_container == null: return
	var stream:AudioStream = bgm_container.bgm_list.pick_random()
	if stream == null: return
	bgm_player.stream = stream
	bgm_player.play()		


func stop_music() -> void:
	bgm_player.stop()
		
		
func play_sfx(sfx_id:SfxContainer.SfxID) -> void:
	if sfx_player ==  null: return
	if sfx_container == null: return
	var stream:AudioStream = sfx_container.sfx_list.get(sfx_id, null)
	if stream == null: return
	sfx_player.stream = stream
	sfx_player.play()
	
	
func _on_music_stop() -> void:
	await Helper.wait_for_seconds(0.5)
	play_music()
