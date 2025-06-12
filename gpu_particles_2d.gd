@tool extends GPUParticles2D

@onready var gun: Gun = get_parent().get_parent()

var is_mouse_pressed: bool = false

var current_emiting_time: float = 0

func _ready() -> void:
	print("connect Gun -> GPUParticles2D")
	gun.fire_particle_signal.connect(handle_fire_signal)
	
func _process(delta: float) -> void:
	process_material.initial_velocity_min = 500
	current_emiting_time -= delta
	if current_emiting_time < 0:
		emitting = false

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("click"):
		is_mouse_pressed = true
		
	elif Input.is_action_just_released("click"):
		is_mouse_pressed = false
	
	
func handle_fire_signal(emiting_time: float):
	current_emiting_time = emiting_time
	emitting = true
	
