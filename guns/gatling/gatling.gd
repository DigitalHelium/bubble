class_name Gatling extends BaseGun

func _ready():
	super._ready()
	particle_damage = 30
	acceleration = 30
	shot_rejection = -0.9
	rejection_duration = 0.1
	
	start_damage_duration = 0.1
	reload_time = 0.1
	duration_shot_fire = 0.1
	spread_amount = 2
	damageAreaSize = Vector2(150.0, 55.0) 
