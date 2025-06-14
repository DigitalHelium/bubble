extends Control

var flag = false

func _ready():
	$AnimationPlayerB.play("start")
	
func _process(delta: float) -> void:
	if $nextB.is_hovered() and $"Sound button/SoundRate".time_left == 0 and !flag:
		$"Sound button".play()
		$"Sound button/SoundRate".start()
	
	flag = true
	if !$nextB.is_hovered() and flag:
		$"Sound button/SoundRate".stop()
		flag = false
		


func _on_next_b_pressed() -> void:
		SceneTransition.change_scene("res://menu/menu.tscn")
		DisplayServer.cursor_set_custom_image(load("res://texture/cursor-export.png"), 0, Vector2(0,0))
		$AnimationPlayerB.play("end")


func _on_next_b_mouse_entered() -> void:
	$nextB.set_button_icon(load("res://menu/СтрелкаHover.png"))


func _on_next_b_mouse_exited() -> void:
	$nextB.set_button_icon(load("res://menu/Стрелка0.png"))
