class_name BubbleCharacter extends CharacterBody2D

@export var max_speed : float = 220.0
@export var max_acceleration : float = 100.0
@export var friction : float = 3.0

var acceleration : float = 0
var direction : Vector2

func get_input_keyboard() -> Vector2:
	var direction : Vector2
	direction.x = Input.get_axis("ui_right", "ui_left")
	direction.y = Input.get_axis("ui_down", "ui_up")
	return direction

func fade_acceleration(acceleration: float) -> float:
	var new_acceleration = move_toward(acceleration, 0, 10)
	#print (clamp(new_acceleration, 0, max_acceleration))
	return new_acceleration

func calc_velocity(current_velocity : Vector2, acceleration: float) -> Vector2:
	if acceleration != 0:
		current_velocity.x = move_toward(current_velocity.x, direction.x * max_speed, acceleration)
		current_velocity.y = move_toward(current_velocity.y, direction.y * max_speed, acceleration)
	else:
		current_velocity.x = move_toward(current_velocity.x, 0, friction)
		current_velocity.y = move_toward(current_velocity.y, 0, friction)
	return current_velocity

func _physics_process(delta) -> void:
	#print(["Before: ", acceleration])
	acceleration = fade_acceleration(acceleration)
	#print(["After: ", acceleration])
	velocity = calc_velocity(velocity, acceleration)
	#print(velocity)
	move_and_slide()


func handle_fire_event(acceleration_delta : float, gun_direction: Vector2) -> void:
	#print("ПОГНАЛИ НАХУЙ")
	acceleration += acceleration_delta
	direction = gun_direction
