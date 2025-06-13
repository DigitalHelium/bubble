extends Sprite2D

@onready var animation_player = %AnimationPlayer
@onready var hand = %"Hand (Sprite2D)"

@onready var body_sprites = [
	%"Body (Sprite2D)",
	%"Left leg (Sprite2D)",
	%"Right leg (Sprite2D)"
]

var spring_intensity = 1.0
var last_mouse_position: Vector2
var facing_right: bool = true

func _ready():
	last_mouse_position = get_global_mouse_position()
	animation_player.play("spring")

func _process(delta):
	handle_body_flipping()

func handle_body_flipping():
	var mouse_pos = get_global_mouse_position()
	var should_face_right = mouse_pos.x > global_position.x
	if should_face_right != facing_right:
		facing_right = should_face_right
		flip_all_body_sprites()
		
func flip_all_body_sprites():
	for sprite in body_sprites:
		if sprite != null:
			sprite.flip_h = not facing_right
		hand.flip_h = not facing_right
		hand.position.x = -hand.position.x

func set_spring_intensity(intensity: float):
	spring_intensity = intensity
	animation_player.speed_scale = intensity
