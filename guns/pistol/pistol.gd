class_name Pistol extends BaseGun

func _ready():
	super._ready()
	particle_damage = 60
	acceleration = 90
	shot_rejection = 1.3
	rejection_duration = 0.7
	
	start_damage_duration = 0.1
	reload_time = 0.1
	duration_shot_fire = 0.5
	spread_amount = 2
