@tool
class_name BackgroundWater extends Sprite2D

var current_velocity : Vector2 = Vector2(0,0) 

func _ready():
	var character = get_parent()
	if character != null and character is BubbleCharacter:
		character.velocity_update_signal.connect(handle_movement_signel)
	
	var viewpoert_size = Vector2(get_viewport().size)
	var texture_size = texture.get_size()
	scale = viewpoert_size / texture_size

func calculate_aspect_ratio():
	#print(scale.y / scale.x)	
	#print(scale.y / scale.x)	
	material.set_shader_parameter("aspect_ratio", scale.y / scale.x)

func handle_movement_signel(character_position: Vector2):
	print(character_position)
	current_velocity = character_position * 0.0001
	material.set_shader_parameter("movement_direction", current_velocity)

	
