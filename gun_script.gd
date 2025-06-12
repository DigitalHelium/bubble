class_name Gun extends Node2D

var button_time_held = 0.0

signal fire_signal
signal fire_particle_signal

enum GUN_TYPE {AUTOMATIC = 1, SHOTGUN = 10}
# var GunChild gun
@export var automatic_acceleration : float = 30.0
@export var shotgun_acceleration : float = 100.0

@onready var character : BubbleCharacter = get_parent()

var direction : Vector2

func _ready():
	fire_signal.connect(character.handle_fire_event)
	
func calc_held_time(delta: float, button_time_held: float) -> float:
	return button_time_held - delta


func check_if_shot_fired(button_time_held: float, direction : Vector2, type: GUN_TYPE) -> float:
		
	if type == GUN_TYPE.AUTOMATIC and button_time_held < 0:
		fire_signal.emit(automatic_acceleration, direction)
		fire_particle_signal.emit(0.2)
		return 0.1
	if type == GUN_TYPE.SHOTGUN and button_time_held < 0:
		fire_signal.emit(shotgun_acceleration, direction)
		fire_particle_signal.emit(0.05)
		return 1.5
	return button_time_held

func abstract_check_fire(hold_time: float, force: Vector2) -> void:
	if hold_time >= 0.1:
		fire_signal.emit(shotgun_acceleration, force)


func _physics_process(delta) -> void:
	button_time_held = clamp(calc_held_time(delta, button_time_held), -1, 1)
	if Input.is_action_pressed("click"):
		button_time_held = check_if_shot_fired(button_time_held, -direction, GUN_TYPE.AUTOMATIC)


var radius := 32.0

func _process(delta: float) -> void:
	direction = (get_global_mouse_position() - get_parent().global_position).normalized()
	position = direction * radius
	rotation = direction.angle()

	
