class_name BaseGun extends Node2D

var button_time_held = 0.0

signal fire_signal
signal fire_particle_signal

@export var acceleration : float = 30.0
@export var particle_damage : int = 25
@export var reload: float = 0.2
@export var start_damage_duration: float = 0.2
@export var radius = 32.0
@export var damageAreaSize: Vector2 = Vector2(100, 50) 
@onready var character : BubbleCharacter = null

var direction : Vector2
var particles_area: Area2D
var is_firing: bool = false

func _ready():
	setup_damage_detection()
	
func initialize(char: BubbleCharacter):
	character = char
	fire_signal.connect(character.handle_fire_event)

func setup_damage_detection() -> void:
	particles_area = Area2D.new()
	particles_area.name = "GunDamageArea"
	add_child(particles_area)
	
	var collision_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = damageAreaSize
	collision_shape.shape = shape
	particles_area.add_child(collision_shape)
	
	particles_area.position = Vector2(50, 0) 
	particles_area.body_entered.connect(_on_damage_area_body_entered)
	particles_area.monitoring = false

func calc_held_time(delta: float, button_time_held: float) -> float:
	return button_time_held - delta

func check_if_shot_fired(button_time_held: float, direction : Vector2) -> float:
	if button_time_held < 0:
		fire_signal.emit(acceleration, direction)
		fire_particle_signal.emit(reload)
		start_damage_detection(start_damage_duration)
		return 0.1
	return button_time_held

func start_damage_detection(duration: float) -> void:
	is_firing = true
	particles_area.monitoring = true
	# таймер до отключения дамага
	var timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(stop_damage_detection)
	timer.timeout.connect(timer.queue_free)
	timer.start()

func stop_damage_detection() -> void:
	is_firing = false
	particles_area.monitoring = false

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body is Enemy and is_firing:
		body.take_damage(particle_damage)
		print("Урон: ", particle_damage)

func _physics_process(delta) -> void:
	button_time_held = clamp(calc_held_time(delta, button_time_held), -1, 1)
	if Input.is_action_pressed("click"):
		button_time_held = check_if_shot_fired(button_time_held, -direction)

func _process(delta: float) -> void:
	direction = (get_global_mouse_position() - get_parent().global_position).normalized()
	position = direction * radius
	rotation = direction.angle()
	
	if particles_area:
		particles_area.rotation = 0 
