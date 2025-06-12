class_name Gun extends Node2D

var button_time_held = 0.0

signal fire_signal
signal fire_particle_signal

enum GUN_TYPE {AUTOMATIC = 1, SHOTGUN = 10}

@export var automatic_acceleration : float = 30.0
@export var shotgun_acceleration : float = 100.0
@export var particle_damage : int = 25

@onready var character : BubbleCharacter = get_parent()

var direction : Vector2
var particles_area: Area2D
var is_firing: bool = false

func _ready():
	fire_signal.connect(character.handle_fire_event)
	setup_damage_detection()

func setup_damage_detection() -> void:
	particles_area = Area2D.new()
	particles_area.name = "GunDamageArea"
	add_child(particles_area)
	
	var collision_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(100, 50) 
	collision_shape.shape = shape
	particles_area.add_child(collision_shape)
	
	particles_area.position = Vector2(50, 0) 
	particles_area.body_entered.connect(_on_damage_area_body_entered)
	particles_area.monitoring = false

func calc_held_time(delta: float, button_time_held: float) -> float:
	return button_time_held - delta

func check_if_shot_fired(button_time_held: float, direction : Vector2, type: GUN_TYPE) -> float:
	if type == GUN_TYPE.AUTOMATIC and button_time_held < 0:
		fire_signal.emit(automatic_acceleration, direction)
		fire_particle_signal.emit(0.2)
		start_damage_detection(0.2)
		return 0.1
	if type == GUN_TYPE.SHOTGUN and button_time_held < 0:
		fire_signal.emit(shotgun_acceleration, direction)
		fire_particle_signal.emit(0.05)
		start_damage_detection(0.05)
		return 1.5
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
		#print("Урон: ", particle_damage)

func _physics_process(delta) -> void:
	button_time_held = clamp(calc_held_time(delta, button_time_held), -1, 1)
	if Input.is_action_pressed("click"):
		button_time_held = check_if_shot_fired(button_time_held, -direction, GUN_TYPE.AUTOMATIC)

var radius := 32.0

func _process(delta: float) -> void:
	direction = (get_global_mouse_position() - get_parent().global_position).normalized()
	position = direction * radius
	rotation = direction.angle()
	
	if particles_area:
		particles_area.rotation = 0 
