class_name Enemy extends CharacterBody2D

@onready var target : BubbleCharacter = $"../Character (main_bubble)"
@onready var nav := $NavigationAgent2D
@onready var animation_attack := $"AnimatedSprite2D (Body)"
@onready var animation_legs := $"AnimatedSprite2D (Legs)"
@onready var timer_deceleration := $"Timer (Speed)"

var DEFAULT_SPEED = 300
var SPEED_DECELERATION = 150
var LOOK_ACCELERATION = 10
var ACCELERATION = 0.01
var PUSHING_FORCE_MULTIPLIER = 400 #насколько сильно отбрасывает
var PUSHING_FORCE_FADE_ACCEL = 0.02 #насколько быстро враги возвращают свою скорость
var ENEMY_BACKWARDS_VELOCITY_MULTIPLIER = 50 #насколько сильно можно изменить скорость врагу при выстреле в него

var speed = DEFAULT_SPEED
var pushing_force : float = 0
var current_direction = Vector2(0, 0)
var current_target_position

var MAX_HEALTH = 300
var current_health = MAX_HEALTH
var is_dead = false

# сигнал о смерти врага
signal enemy_died

func _ready() -> void:
	current_target_position = target.position
	animation_legs.play("default")
	timer_deceleration.stop()

func _physics_process(delta: float) -> void:
	if is_dead:
		movement_at_death()
		return
	if target != null :
		move_on_target()
	pushing_force = fade_pushing_force(pushing_force)

func calculate_direction() -> Vector2:
	var next_direction = ((nav.get_next_path_position()-position)).normalized()
	current_direction.x = move_toward(current_direction.x, next_direction.x, ACCELERATION)
	current_direction.y = move_toward(current_direction.y, next_direction.y, ACCELERATION)
	return current_direction

func calculate_target_position() -> Vector2:
	current_target_position.x = move_toward(current_target_position.x, nav.target_position.x, LOOK_ACCELERATION)
	current_target_position.y = move_toward(current_target_position.y, nav.target_position.y, LOOK_ACCELERATION)
	return current_target_position

func calculate_escape_position() -> Vector2:
	var direction_to_target = target.position - position
	var x = -5000.0 if (direction_to_target.x > 0) else 5000.0
	var y = -5000.0 if (direction_to_target.y > 0) else 5000.0
	return Vector2(x, y)

func _on_timer_timeout() -> void:
	if is_dead:
		nav.target_position = calculate_escape_position()
		return
	nav.target_position = target.position

func take_damage(damage_amount: int, shot_rejection: float, rejection_duration: float) -> void:
	if is_dead:
		return
	
	current_health -= damage_amount
	timer_deceleration.start(rejection_duration)
	#speed = SPEED_DECELERATION
	pushing_force = -shot_rejection
	print("Дамаг: ", damage_amount, " HP: ", current_health)
	if current_health <= 0:
		die()

func die() -> void:
	is_dead = true
	pushing_force = 0
	current_target_position = calculate_escape_position()
	print("сдох")
	emit_signal("enemy_died")
	animation_attack.stop()
	$CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(10).timeout
	queue_free()

func _on_timer_speed_timeout() -> void:
	speed = DEFAULT_SPEED
	timer_deceleration.stop()

func move(direction: Vector2) -> void:
	velocity.x = direction.x * speed
	velocity.y = direction.y * speed
	velocity.x = move_toward(velocity.x, -velocity.x * ENEMY_BACKWARDS_VELOCITY_MULTIPLIER, pushing_force * PUSHING_FORCE_MULTIPLIER)
	velocity.y = move_toward(velocity.y, -velocity.y * ENEMY_BACKWARDS_VELOCITY_MULTIPLIER, pushing_force * PUSHING_FORCE_MULTIPLIER)
	look_at(calculate_target_position())
	move_and_slide()
	
func fade_pushing_force(pushing_force : float) -> float:
	return move_toward(pushing_force, 0, PUSHING_FORCE_FADE_ACCEL)
	
func movement_at_death() -> void:
	move(current_target_position.normalized())

func move_on_target() -> void:
	move(calculate_direction())
	if nav.get_current_navigation_path().size() < 7:
		animation_attack.play('attack')
	else :
		animation_attack.stop()


func _on_area_2d_body_entered(body) -> void:
	
	pass 
