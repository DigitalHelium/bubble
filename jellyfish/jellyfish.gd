extends CharacterBody2D

@onready var player : BubbleCharacter = $"../Character (main_bubble)"

@export var speed = 300
@export var follow_radius = 40

func _physics_process(delta: float) -> void:
	if player != null:
		move_on_player(delta)

func move_on_player(delta: float) -> void:
	var next_direction = player.next_mission_direction
	if next_direction != null:
		#print("next_direction", next_direction)
		var direction = next_direction - position
		velocity = direction * 2 
		#velocity.y = move_toward(position.y, direction.y, 0.01) * speed
		#print((next_direction * follow_radius - position))
		move_and_slide()
