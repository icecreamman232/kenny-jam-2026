class_name BubleText extends RichTextLabel

const SHOW_DURATION:float = 0.75
const DISAPPEAR_DURATION:float = 0.3

func show_text(message:String):
	text = message
	show()
	await Helper.wait_for_seconds(SHOW_DURATION)
	var appear_tween := _appear_tween()
	await appear_tween.finished
	queue_free()
	
		
func _appear_tween() ->Tween:
	var tween:= create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "modulate", Color(1,1,1,0), DISAPPEAR_DURATION)
	return tween

