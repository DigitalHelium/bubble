@tool
class_name BackgroundWater extends Sprite2D

var current_direction : Vector2 = Vector2(0,0) 

func _ready():
	var character: BubbleCharacter = $"../Character (main_bubble)"
	character.velocity_update_signal.connect(handle_movement_signel)

func calculate_aspect_ratio():
	#print(scale.y / scale.x)	
	material.set_shader_parameter("aspect_ratio", scale.y / scale.x)

func handle_movement_signel(direction: Vector2):
	#print(direction)
	current_direction.x = move_toward(current_direction.x, direction.x, 0.1)
	current_direction.y = move_toward(current_direction.y, direction.y, 0.1)
	material.set_shader_parameter("movement_direction", current_direction.normalized())
