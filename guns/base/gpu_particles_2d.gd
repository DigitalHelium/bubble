class_name GpuParticles extends GPUParticles2D

@onready var gun: BaseGun = get_parent().get_parent()

var mouse_hold_time: float = 0.0
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
		
	var mouse_pos = get_global_mouse_position()
	var pos = get_parent().get_parent().get_parent().position
	var r = get_parent().get_parent().radius
	if !((mouse_pos.x <= (pos.x-r)) or (mouse_pos.x >= (pos.x+r)) or ( mouse_pos.y <= (pos.y-r)) or ( mouse_pos.y >= (pos.y+r))):
		return

func _unhandled_input(event: InputEvent) -> void:
	var mouse_pos = get_global_mouse_position()
	var pos = get_parent().get_parent().get_parent().position
	var r = get_parent().get_parent().radius
	if !((mouse_pos.x <= (pos.x-r)) or (mouse_pos.x >= (pos.x+r)) or ( mouse_pos.y <= (pos.y-r)) or ( mouse_pos.y >= (pos.y+r))):
		return
	if Input.is_action_just_pressed("click"):
		is_mouse_pressed = true
		
	if Input.is_action_just_released("click"):
		is_mouse_pressed = false
	
	
	
func handle_fire_signal(emiting_time: float, spread_amount: float):
	print(emiting_time, spread_amount)
	current_emiting_time = emiting_time
	emitting = true
	process_material.set("spread", spread_amount)
	
