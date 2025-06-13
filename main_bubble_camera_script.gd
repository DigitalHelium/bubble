extends Camera2D

@export var follow_speed = 5.0
@export var smooth_distance = 5.0 

var target_position : Vector2
var current_accel : float
var current_decel : float
var current_velocity : Vector2
var max_speed = 10

#func _physics_process(delta):
	#var parent = get_parent()
	#if parent != null and parent is BubbleCharacter:
		#if parent.velocity.x > 5 or parent.velocity.y > 5:
			#current_accel = 10
	#
	#if current_accel > 0:
		#current_velocity.x = move_toward(current_velocity.x, parent.direction.x * max_speed, current_accel)
		#current_velocity.y = move_toward(current_velocity.y, parent.direction.y * max_speed, current_accel)
		#global_position += current_velocity * delta
		#current_accel = move_toward(current_accel, 0, 10)
	#else:
		#current_decel = 0.4
	#
	#if current_decel > 0:
		#global_position.x = move_toward(global_position.x, parent.global_position.x, current_decel)
		#global_position.y = move_toward(global_position.y, parent.global_position.y, current_decel)
		#current_decel = move_toward(current_decel, 0, 0.03)
		
	
