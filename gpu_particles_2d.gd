@tool extends GPUParticles2D

signal mouse_hold(hold_time: float, force: Vector2)

@onready var gun: Gun = get_parent().get_parent()


var mouse_hold_time: float = 0.0
var is_mouse_pressed: bool = false
var min_distance: float = 5.0

func _ready() -> void:
	mouse_hold.connect(gun.abstract_check_fire)
	
func _process(delta: float) -> void:
	if is_mouse_pressed:
		var mouse_pos = get_global_mouse_position()
		var pos = get_parent().get_parent().get_parent().position
		var r = get_parent().radius
		if !((mouse_pos.x <= (pos.x-r)) or (mouse_pos.x >= (pos.x+r)) or ( mouse_pos.y <= (pos.y-r)) or ( mouse_pos.y >= (pos.y+r))):
			return
		print(mouse_pos, "mouse_pos")
		print(get_parent().get_parent().get_parent().position, "position")
		var distance_to_mouse = global_position.distance_to(mouse_pos)
		
		if distance_to_mouse < min_distance:
			return
			
		mouse_hold_time += delta
		var direction: Vector2 = (mouse_pos -  global_position).normalized()
		var gravity_force: int = 280
		var gravity: Vector3 = Vector3(direction.x, direction.y, 0) * gravity_force
		process_material.set_gravity(gravity)
		
		var recoil_force: Vector2 = -direction * 1.09
		print(mouse_hold, recoil_force)
		mouse_hold.emit(mouse_hold_time, recoil_force)

func _unhandled_input(event: InputEvent) -> void:
	var mouse_pos = get_global_mouse_position()
	var r = get_parent().radius
	var pos = get_parent().get_parent().get_parent().position

	print(mouse_pos.x, "mouse before")
	print(pos.x, "pos before")
	#
	if (mouse_pos.x < (pos.x-r)) or (mouse_pos.x > (pos.x+r)) or ( mouse_pos.y < (pos.y-r)) or ( mouse_pos.y > (pos.y+r)):
		print(mouse_pos.x, "mouse after")
		print(pos.x, "pos after")
		if Input.is_action_just_pressed("click"):
			is_mouse_pressed = true
			mouse_hold_time = 0.0
			emitting = true

		
	if Input.is_action_just_released("click"):
		is_mouse_pressed = false
		mouse_hold_time = 0.0
		emitting = false
