class_name Pistol extends BaseGun

func _ready():
	super._ready()
	particle_damage = 15
	acceleration = 90
	
	start_damage_duration = 0.1
	reload_time = 0.1
	duration_shot_fire = 0.5
	spread_amount = 2
