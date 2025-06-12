extends Sprite2D

var radius := 32.0

func _process(delta: float) -> void:
	position = (get_global_mouse_position() - get_parent().position).normalized() * radius
	look_at(get_global_mouse_position())
