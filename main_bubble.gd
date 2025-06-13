class_name BubbleCharacter extends CharacterBody2D

@export var max_speed : float = 220.0
@export var max_acceleration : float = 100.0
@export var friction : float = 3.0
var current_gun = null

var gun_scenes = {
	"pistol": preload("res://guns/pistol/pistol.tscn"),
	"shotgun": preload("res://guns/shotgun/shotgun.tscn")
}

var acceleration : float = 0
var direction : Vector2

signal velocity_update_signal

func _ready() -> void:
	change_weapon("pistol")
	
func change_weapon(weapon_name: String):
	if weapon_name in gun_scenes:
		if current_gun:
			current_gun.queue_free()
		var new_gun = gun_scenes[weapon_name].instantiate()
		add_child(new_gun)
		if new_gun.has_method("initialize"):
			new_gun.initialize(self)
		current_gun = new_gun

func fade_acceleration(acceleration: float) -> float:
	var new_acceleration = move_toward(acceleration, 0, 10)
	#print (clamp(new_acceleration, 0, max_acceleration))
	return new_acceleration

func calc_velocity(current_velocity : Vector2, acceleration: float) -> Vector2:
	if acceleration != 0:
		current_velocity.x = move_toward(current_velocity.x, direction.x * max_speed, acceleration)
		current_velocity.y = move_toward(current_velocity.y, direction.y * max_speed, acceleration)
	else:
		current_velocity.x = move_toward(current_velocity.x, 0, friction)
		current_velocity.y = move_toward(current_velocity.y, 0, friction)
	return current_velocity

func _physics_process(delta) -> void:
	acceleration = fade_acceleration(acceleration)
	velocity = calc_velocity(velocity, acceleration)
	move_and_slide()
	
	velocity_update_signal.emit(position)
	


func handle_fire_event(acceleration_delta : float, gun_direction: Vector2) -> void:
	acceleration += acceleration_delta
	direction = gun_direction

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("LKKL 222")
	if body.has_method("collect"):
		body.collect()
