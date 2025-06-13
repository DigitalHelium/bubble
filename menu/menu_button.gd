extends VBoxContainer
var flag = false
var flag2 = false
func _process(delta: float) -> void:
	if $StartButton.is_hovered() and $"Sound button/SoundRate".time_left == 0 and !flag:
		$"Sound button".play()
		$"Sound button/SoundRate".start()
		flag = true
	if !$StartButton.is_hovered() and flag:
		#$"Sound button".stop()
		$"Sound button/SoundRate".stop()
		flag = false
		
		
	if $QuitButton.is_hovered()  and $"Sound button/SoundRate".time_left == 0 and !flag2:
		$"Sound button".play()
		$"Sound button/SoundRate".start()
		flag2 = true
	if !$QuitButton.is_hovered() and flag2:
		#$"Sound button".stop()
		$"Sound button/SoundRate".stop()

		flag2 = false

	
		
	
	#get_child().is_hovered()

	
