extends Control


var flag = false
var number = 1
var one = load("res://texture/background_menu/cat-scene1.png")
var two =  load("res://texture/background_menu/cat-scene2.png")

func _on_ready():
		$AnimationPlayer.play("start")
func _process(delta: float) -> void:
	if $next.is_hovered() and $"Sound button/SoundRate".time_left == 0 and !flag:
		$"Sound button".play()
		$"Sound button/SoundRate".start()
		flag = true
	if !$next.is_hovered() and flag:
		$"Sound button/SoundRate".stop()
		flag = false
		


func _on_next_pressed() -> void:
	var texture = one
	if number == 1:
		texture = one
		number = 2
	elif number == 2:
		texture = two
		number = 0
	else:
		SceneTransition.change_scene("res://prod scenes/prod_scene.tscn")
		DisplayServer.cursor_set_custom_image(load("res://texture/cursor-export.png"), 0, Vector2(0,0))
		$AnimationPlayer.play("end")
		return
	
	$AnimationPlayer.play("end")
	await $AnimationPlayer.animation_finished
	$"Cat-scene0".set_texture(texture) 
	$AnimationPlayer.play("start")
	


func _on_next_mouse_entered() -> void:
	$next.set_button_icon(load("res://menu/СтрелкаHover.png"))
	


func _on_next_mouse_exited() -> void:
	$next.set_button_icon(load("res://menu/Стрелка0.png"))
