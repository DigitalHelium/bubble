extends Sprite2D

@onready var gun_root: Gun = get_parent()

func _process(delta: float) -> void:
	if gun_root != null:
		flip_v = gun_root.direction.x < 0
