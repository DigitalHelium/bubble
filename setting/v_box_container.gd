extends VBoxContainer

var flag = false
var flag2 = false
var flag3 = false
func _process(delta: float) -> void:
	if $"../../MenuButton".is_hovered() and $"Sound button/SoundRate".time_left == 0 and !flag:
		$"Sound button".play()
		$"Sound button/SoundRate".start()
		flag = true
	if !$"../../MenuButton".is_hovered() and flag:
		$"Sound button/SoundRate".stop()
		flag = false
	
