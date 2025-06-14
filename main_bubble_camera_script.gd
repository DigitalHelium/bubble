extends Camera2D

@export var follow_speed = 5.0
@export var smooth_distance = 5.0 

var lerp_speed : float = 100
var max_velocity : float = 20
var min_velocity : float = -20
var current_velocity: Vector2
		
func _process(delta):
	var parent = get_parent()
	if parent != null and parent is BubbleCharacter:
		var velocity : Vector2
		velocity.x = max(min(parent.velocity.x, max_velocity),min_velocity)
		velocity.y = max(min(parent.velocity.y, max_velocity),min_velocity)
		position = position.lerp(velocity, delta * smoothstep(min_velocity, max_velocity, velocity.length()))
	
