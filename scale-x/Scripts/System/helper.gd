extends Node


func print_enum(enum_type:Dictionary, enum_value:int) ->String:
	return enum_type.keys()[enum_value]
	

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
	
	
func get_color_by_rarity(rarity:ItemData.ItemRarity) ->Color:
	match rarity:
		ItemData.ItemRarity.COMMON:
			return Constant.COMMON_ITEM_COLOR
		ItemData.ItemRarity.UNCOMMON:
			return Constant.UNCOMMON_ITEM_COLOR
		ItemData.ItemRarity.RARE:
			return Constant.RARE_ITEM_COLOR
		ItemData.ItemRarity.LEGENDARY:
			return Constant.LEGENDARY_ITEM_COLOR
		ItemData.ItemRarity.EPIC:
			return Constant.EPIC_ITEM_COLOR
		_: return Color.WHITE	
		
		
func get_adjacent_cell_index(cell_index: int) -> Array[int]:
	var result: Array[int] = []
	var not_left      := cell_index % 3 != 0
	var not_right     := cell_index % 3 != 2
	var has_row_above := cell_index >= 3
	var has_row_below := cell_index <= 5
	if has_row_above: result.append(cell_index - 3)
	if has_row_below: result.append(cell_index + 3)
	if not_left:      result.append(cell_index - 1)
	if not_right:     result.append(cell_index + 1)
	if has_row_above and not_left:  result.append(cell_index - 4)
	if has_row_above and not_right: result.append(cell_index - 2)
	if has_row_below and not_left:  result.append(cell_index + 2)
	if has_row_below and not_right: result.append(cell_index + 4)
	return result
