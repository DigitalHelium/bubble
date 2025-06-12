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

var speed = DEFAULT_SPEED
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
		return
	if target != null :
		var direction = calculate_direction()
		velocity.x = direction.x * speed
		velocity.y = direction.y * speed
		look_at(calculate_target_position())
		move_and_slide()
		
		if nav.get_current_navigation_path().size() < 13 :
			animation_attack.play('attack')
		else :
			animation_attack.stop()

func calculate_direction() -> Vector2:
	var next_direction = ((nav.get_next_path_position()-position)).normalized()
	current_direction.x = move_toward(current_direction.x, next_direction.x, ACCELERATION)
	current_direction.y = move_toward(current_direction.y, next_direction.y, ACCELERATION)
	return current_direction

func calculate_target_position() -> Vector2:
	current_target_position.x = move_toward(current_target_position.x, target.position.x, LOOK_ACCELERATION)
	current_target_position.y = move_toward(current_target_position.y, target.position.y, LOOK_ACCELERATION)
	return current_target_position

func _on_timer_timeout() -> void:
	nav.target_position = target.position

func take_damage(damage_amount: int) -> void:
	if is_dead:
		return
		
	current_health -= damage_amount
	timer_deceleration.start(1)
	speed = SPEED_DECELERATION
	#print("Дамаг: ", damage_amount, " HP: ", current_health)
	if current_health <= 0:
		die()

func die() -> void:
	is_dead = true
	print("сдох")
	emit_signal("enemy_died")
	$CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(0.5).timeout
	queue_free()

func _on_timer_speed_timeout() -> void:
	speed = DEFAULT_SPEED
	timer_deceleration.stop()
