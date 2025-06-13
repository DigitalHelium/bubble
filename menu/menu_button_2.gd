extends HBoxContainer
var flag = false
var flag2 = false
var flag3 = false
func _process(delta: float) -> void:
	if %"1".is_hovered() and $"Sound button/SoundRate".time_left == 0 and !flag:
		$"Sound button".play()
		$"Sound button/SoundRate".start()
		flag = true
	elif !%"1".is_hovered() and flag:
		#$"Sound button".stop()
		$"Sound button/SoundRate".stop()
		flag = false
	elif %"2".is_hovered()  and $"Sound button/SoundRate".time_left == 0 and !flag2:
		$"Sound button".play()
		$"Sound button/SoundRate".start()
		flag2 = true
	elif !%"2".is_hovered() and flag2:
		#$"Sound button".stop()
		$"Sound button/SoundRate".stop()
		flag2 = false
	elif $"../MenuButton".is_hovered()  and $"Sound button/SoundRate".time_left == 0 and !flag3:
		$"Sound button".play()
		$"Sound button/SoundRate".start()
		flag3 = true
	elif !$"../MenuButton".is_hovered() and flag3:
		#$"Sound button".stop()
		$"Sound button/SoundRate".stop()
		flag3 = false

	
		
	
	#get_child().is_hovered()

	
