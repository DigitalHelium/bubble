class_name Enemy extends CharacterBody2D

@onready var target : BubbleCharacter
@onready var nav := $NavigationAgent2D
@onready var animation_attack := $"AnimatedSprite2D (Body)"
@onready var animation_legs := $"AnimatedSprite2D (Legs)"
@onready var timer_deceleration := $"Timer (Speed)"

var DEFAULT_SPEED = 150
var SPEED_DECELERATION = 150
var LOOK_ACCELERATION = 10
var ACCELERATION = 0.01
var PUSHING_FORCE_MULTIPLIER = 400 #насколько сильно отбрасывает
var PUSHING_FORCE_FADE_ACCEL = 0.02 #насколько быстро враги возвращают свою скорость
var ENEMY_BACKWARDS_VELOCITY_MULTIPLIER = 50 #насколько сильно можно изменить скорость врагу при выстреле в него
var DAMAGE_PULSE_RADIUS = 150 #радиус отбрасывания врагов

var speed = DEFAULT_SPEED
var pushing_force : float = 0
var current_direction = Vector2(0, 0)
var current_target_position

var MAX_HEALTH = 300
var current_health = MAX_HEALTH
var is_dead = false

var ruby = preload("res://gems/bubble gems/ruby bubble gem/RubyBubbleGem.tscn")
var saphire = preload("res://gems/bubble gems/sapphire bubble gem/SapphireBubbleGem.tscn")
var topaz = preload("res://gems/bubble gems/topaz bubble gem/TopazBubbleGem.tscn")

# сигнал о смерти врага
signal enemy_died

func _ready() -> void:
	if target == null:
		target = $"../Character (main_bubble)"
	if target != null:
		current_target_position = target.position
	animation_legs.play("default")
	timer_deceleration.stop()
	target.enemy_push_after_damage_signal.connect(recive_impulse)

func set_target(target : BubbleCharacter) -> void:
	self.target = target

func set_current_target_position(current_target_position : Vector2) -> void:
	self.current_target_position = current_target_position

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
	if is_instance_valid(target):
		var direction_to_target = target.position - position
		var x = -5000.0 if (direction_to_target.x > 0) else 5000.0
		var y = -5000.0 if (direction_to_target.y > 0) else 5000.0
		return Vector2(x, y)
	return Vector2(0,0)

func _on_timer_timeout() -> void:
	if is_dead:
		nav.target_position = calculate_escape_position()
		return
	if is_instance_valid(target):
		nav.target_position = target.position

func take_damage(damage_amount: int, shot_rejection: float, rejection_duration: float) -> void:
	if is_dead:
		return
	
	current_health -= damage_amount
	timer_deceleration.start(rejection_duration)
	#speed = SPEED_DECELERATION
	pushing_force = shot_rejection
	print("Дамаг: ", damage_amount, " HP: ", current_health)
	if current_health <= 0:
		kill_enemy()

func kill_enemy() -> void:
	is_dead = true
	pushing_force = 0
	current_target_position = calculate_escape_position()
	print("сдох")
	enemy_died.emit(self)
	drop_gem_for_escape()
	#emit_signal("enemy_died")
	animation_attack.stop()
	$CollisionShape2D.set_deferred("disabled", true)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(10).timeout
	queue_free()

func drop_gem_for_escape() -> void:
	var gem_percent = randi_range(0,100)
	var gem
	print(gem_percent)
	if gem_percent < 50:
		gem = ruby.instantiate()
	elif gem_percent < 80:
		gem = saphire.instantiate()
	else:
		gem = topaz.instantiate()
	gem.position = position
	$"../".add_child(gem)

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

func recive_impulse(shot_rejection: float):

	var player_enemy_distance = (target.global_position - global_position).length()
	if player_enemy_distance < DAMAGE_PULSE_RADIUS:
		pushing_force = shot_rejection

func _on_area_2d_body_entered(body) -> void:
	if body.has_method("receive_damage"):
		body.receive_damage()
	pass 
