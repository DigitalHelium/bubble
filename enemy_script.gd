class_name Enemy extends CharacterBody2D

@onready var target : BubbleCharacter = $"../Character (main_bubble)"
@onready var nav := $NavigationAgent2D

var speed = 150

func _physics_process(delta: float) -> void:
	if target != null :
		var direction = (nav.get_next_path_position()-position).normalized()
		velocity = direction * speed
		look_at(nav.get_next_path_position())
		move_and_slide()

func _on_timer_timeout() -> void:
	nav.target_position = target.position
