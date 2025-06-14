extends Node2D


func _on_menu_button_pressed() -> void:
	$Music.volume_db = -100
	SceneTransition.change_scene("res://menu/menu.tscn")


func _on__pressed_1() -> void:
	$Music.volume_db = -100
	SceneTransition.change_scene("res://prod scenes/prod_scene.tscn")
	print('1')


func _on__pressed_2() -> void:
	$Music.volume_db = -100
	SceneTransition.change_scene("res://Assets/Scenes/Levels/Level_2.tscn")
	print('2')
	pass # Replace with function body.


func _on__pressed_3() -> void:
	$Music.volume_db = -100
	print('3')
	pass # Replace with function body.
