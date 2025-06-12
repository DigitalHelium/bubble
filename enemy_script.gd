class_name Enemy extends CharacterBody2D

@onready var target : BubbleCharacter = $"../Character (main_bubble)"
@onready var nav := $NavigationAgent2D

var speed = 300
var acceleration = 0.01
var look_acceleration = 10
var current_direction = Vector2(0, 0)
var current_target_position

var max_health = 100
var current_health = 100
var is_dead = false

# сигнал о смерти врага
signal enemy_died

func _ready() -> void:
	current_target_position = target.position
	current_health = max_health

func _physics_process(delta: float) -> void:
	if is_dead:
		return
		
	if target != null :
		var direction = calculate_direction()
		velocity.x = direction.x * speed
		velocity.y = direction.y * speed
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

func take_damage(damage_amount: int) -> void:
	if is_dead:
		return
		
	current_health -= damage_amount
	print("Дамаг: ", damage_amount, " HP: ", current_health)
	if current_health <= 0:
		die()

func die() -> void:
	is_dead = true
	print("сдох")
	emit_signal("enemy_died")
	$CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(0.5).timeout
	queue_free()
