extends Node

func wait_for_frames(frames:int):
	for i in range(frames):
		await get_tree().process_frame
		

func wait_for_seconds(seconds:float):
	var timer := get_tree().create_timer(seconds)
	await timer.timeout
	
	
## Convert percent to fraction	
func percent_to_fraction(percent:float) ->float:
	return percent / 100
	

## Convert fraction to percent
func fraction_to_percent(fraction:float) ->float:
	return fraction * 100	