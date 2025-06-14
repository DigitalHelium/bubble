extends Control

func _ready():
	DisplayServer.cursor_set_custom_image(null, 0, Vector2(0,0))
var scene_setting = preload("res://setting/Control.tscn")
func _on_start_button_pressed() -> void:
	#SceneTransition.change_scene("res://Assets/Scenes/Game_with_store.tscn")
	$"Menu_button/Sound button".volume_db = -100
	#SceneTransition.change_scene("res://menu/levels.tscn")
	$Music.volume_db = -100
	SceneTransition.change_scene("res://menu/levels.tscn")

#func _on_teach_button_pressed() -> void:
	##get_tree().change_scene_to_file()
	#SceneTransition.change_scene("res://Assets/Scenes/Game_with_store.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
	$"Menu_button/Sound button".volume_db = -100
	$Music.volume_db = -100

func _on_teach_button_pressed() -> void:
	var scene =  scene_setting.instantiate()
	add_child(scene)
