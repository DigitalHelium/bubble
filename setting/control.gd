extends Control

func _ready() -> void:
	%AnimationSettings.play("animation_setting")
	$MarginContainer/VBoxContainer/Volume_Master.set_value_no_signal(AudioServer.get_bus_volume_db(0))
	$MarginContainer/VBoxContainer/Volume_Sound.set_value_no_signal(AudioServer.get_bus_volume_db(1))
	$MarginContainer/VBoxContainer/Volume_Music.set_value_no_signal(AudioServer.get_bus_volume_db(2))

func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, (value))

func _on_master_mute_toggled(toggled_on: bool) -> void:
	if !toggled_on:
		AudioServer.set_bus_volume_db(0, -100)
		$MarginContainer/VBoxContainer/Volume_Master.editable = false
		
		$MarginContainer/VBoxContainer/Music_Mute.disabled = true
		$MarginContainer/VBoxContainer/Volume_Music.editable = false
		
		$MarginContainer/VBoxContainer/Sound_Mute.disabled = true
		$MarginContainer/VBoxContainer/Volume_Sound.editable = false
	else:
		AudioServer.set_bus_volume_db(0, $MarginContainer/VBoxContainer/Volume_Master.value)
		
		$MarginContainer/VBoxContainer/Volume_Master.editable = true
		
		$MarginContainer/VBoxContainer/Music_Mute.disabled = false
		if $MarginContainer/VBoxContainer/Music_Mute.button_pressed:
			$MarginContainer/VBoxContainer/Volume_Music.editable = true
		
		$MarginContainer/VBoxContainer/Sound_Mute.disabled = false
		if $MarginContainer/VBoxContainer/Sound_Mute.button_pressed:
			$MarginContainer/VBoxContainer/Volume_Sound.editable = true

func _on_volume_music_value_changed(value: float) -> void:
		AudioServer.set_bus_volume_db(2, value)
	
func _on_music_mute_toggled(toggled_on: bool) -> void:
	if !toggled_on:
		AudioServer.set_bus_volume_db(2, -100)
		$MarginContainer/VBoxContainer/Volume_Music.editable = false
	else:
		AudioServer.set_bus_volume_db(2, $MarginContainer/VBoxContainer/Volume_Music.value)
		$MarginContainer/VBoxContainer/Volume_Music.editable = true

func _on_volume_sound_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value)
	

func _on_sound_mute_toggled(toggled_on: bool) -> void:
	if !toggled_on:
		AudioServer.set_bus_volume_db(1, -100)
		$MarginContainer/VBoxContainer/Volume_Sound.editable = false
	else:
		AudioServer.set_bus_volume_db(2, $MarginContainer/VBoxContainer/Volume_Music.value)
		$MarginContainer/VBoxContainer/Volume_Sound.editable = true


func _on_menu_button_pressed() -> void:
	%AnimationSettings.play("animation_end")
	await  %AnimationSettings.animation_finished
	get_tree().paused = false
	queue_free()
