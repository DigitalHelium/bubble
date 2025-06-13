class_name BlunderBuss extends BaseGun

func _ready():
	super._ready()
	particle_damage = 300
	acceleration = 120
	reload_time = 0.009
	start_damage_duration = 0.009
	duration_shot_fire = 1.5
	spread_amount = 40
