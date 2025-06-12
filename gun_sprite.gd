extends Sprite2D

var radius := 32.0

func _process(delta: float) -> void:
	var direction = (get_global_mouse_position() - get_parent().global_position).normalized()
	position = direction * radius
	rotation = direction.angle()
	#look_at(get_parent().global_position + direction)
