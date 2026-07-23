class_name Overlay extends ColorRect

func update_spotlight(target_area:Control) -> void:
	if not target_area or not material:
		return
	var rect := target_area.get_global_rect()
	material.set_shader_parameter("highlight_pos", rect.position)
	material.set_shader_parameter("highlight_size", rect.size)