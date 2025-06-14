extends VBoxContainer
var flag = false
var flag2 = false
var flag3 = false
func _process(delta: float) -> void:
	if $StartButton.is_hovered() and $"Sound button/SoundRate".time_left == 0 and !flag:
		$"Sound button".play()
		$"Sound button/SoundRate".start()
		flag = true
	if !$StartButton.is_hovered() and flag:
		$"Sound button/SoundRate".stop()
		flag = false

func _on_start_button_pressed() -> void:
	
	SceneTransition.change_scene("res://menu/levels.tscn")
