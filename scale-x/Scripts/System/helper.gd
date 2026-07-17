extends Node

func wait_for_frames(frames:int):
	for i in range(frames):
		await get_tree().process_frame
		

func wait_for_seconds(seconds:float):
	var timer := get_tree().create_timer(seconds)
	await timer.timeout