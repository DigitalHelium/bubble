extends ColorRect
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
		
	if $Close.is_hovered() and $"Sound button/SoundRate".time_left == 0 and !flag2:
		$"Sound button".play()
		$"Sound button/SoundRate".start()
		flag2 = true
	if !$Close.is_hovered() and flag2:
		$"Sound button/SoundRate".stop()
		flag2 = false

func _on_start_button_pressed() -> void:
	
	SceneTransition.change_scene("res://prod scenes/prod_scene.tscn")


func _on_close_pressed() -> void:
	SceneTransition.change_scene("res://menu/menu.tscn")
