extends Button

func _process(delta: float) -> void:
	if is_hovered():
		print("hover")
		$"../Sound button"
		
