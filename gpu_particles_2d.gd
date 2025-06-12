@tool extends GPUParticles2D

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("click"):
		emitting = true
		var direction: Vector2 = (get_global_mouse_position() - global_position).normalized()

		var gravity_force: int = 280
		var gravity: Vector3 = Vector3(direction.x, direction.y, 0) * gravity_force

		process_material.set_gravity(gravity)
	else:
		emitting = false
