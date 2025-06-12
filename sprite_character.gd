extends Sprite2D

@onready var animation_player = %AnimationPlayer
@onready var body = %"Body (Sprite2D)"
@onready var hand = %"Hand (Sprite2D)"

var spring_intensity = 1.0
var base_positions = {}

func _ready():
	base_positions["body"] = body.position
	base_positions["hand"] = hand.position
	
	animation_player.play("spring")

func _process(delta):
	pass

func set_spring_intensity(intensity: float):
	spring_intensity = intensity
	animation_player.speed_scale = intensity
