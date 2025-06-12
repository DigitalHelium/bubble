class_name Enemy extends CharacterBody2D

@onready var target : BubbleCharacter = $"../Character (main_bubble)"
@onready var nav := $NavigationAgent2D

var speed = 300
var acceleration = 0.01
var look_acceleration = 10
var current_direction = Vector2(0, 0)
var current_target_position

func _ready() -> void:
	current_target_position = target.position

func _physics_process(delta: float) -> void:
	if target != null :
		var direction = calculate_direction()
		#move_toward()
		velocity.x = direction.x * speed
		velocity.y = direction.y * speed
		#look_at(nav.get_next_path_position())
		look_at(calculate_target_position())
		move_and_slide()

func calculate_direction() -> Vector2:
	var next_direction = ((nav.get_next_path_position()-position)).normalized()
	current_direction.x = move_toward(current_direction.x, next_direction.x, acceleration)
	current_direction.y = move_toward(current_direction.y, next_direction.y, acceleration)
	return current_direction

func calculate_target_position() -> Vector2:
	current_target_position.x = move_toward(current_target_position.x, target.position.x, look_acceleration)
	current_target_position.y = move_toward(current_target_position.y, target.position.y, look_acceleration)
	return current_target_position

func _on_timer_timeout() -> void:
	nav.target_position = target.position
