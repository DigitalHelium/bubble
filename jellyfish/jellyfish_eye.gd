extends Sprite2D
@onready var player : BubbleCharacter = $"../../Character (main_bubble)"

func _physics_process(delta: float) -> void:
	if player != null:
		look_at(player.mission_target.position)
