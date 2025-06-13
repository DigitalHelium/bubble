extends Control
	

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
	
