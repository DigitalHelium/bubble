class_name Shotgun extends BaseGun

func _ready():
	super._ready()
	particle_damage = 150
	reload_time = 0.09
	acceleration = 180.0
	start_damage_duration = 0.09
	duration_shot_fire = 1.5
	spread_amount = 40

func setup_damage_detection() -> void:
	particles_area = Area2D.new()
	particles_area.name = "ShotgunDamageArea"
	add_child(particles_area)
	
	#несколько зон
	for i in range(3):
		var collision_shape = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		shape.size = Vector2(80, 50)
		collision_shape.shape = shape
		# Разброс по вертикали
		collision_shape.position = Vector2(60, (i - 1) * 30)  
		
		particles_area.add_child(collision_shape)
	
	particles_area.position = Vector2(0, 0)
	particles_area.body_entered.connect(_on_damage_area_body_entered)
	particles_area.monitoring = false
