class_name BubbleCharacter extends CharacterBody2D

@export var max_speed : float = 220.0
@export var max_acceleration : float = 100.0
@export var friction : float = 3.0
@export var mission_target : Node2D
@onready var nav := $NavigationAgent2D
@onready var upgrade_screen := $UpgradeScreen
@onready var wallet := $Wallet
var current_gun = null

var gun_scenes = {
	"pistol": preload("res://guns/pistol/pistol.tscn"),
	"shotgun": preload("res://guns/shotgun/shotgun.tscn"),
	"gatling": preload("res://guns/gatling/gatling.tscn")
}

var acceleration : float = 0 #Ускориение персонажа
var direction : Vector2 #Направление стрельбы
var next_mission_direction

var max_health : int = 3 #Максимальное здоровье
var current_health : int = max_health #Текущее здоровье

var gem_count : int = 0


signal velocity_update_signal
signal enemy_push_after_damage_signal
signal change_bubble_after_damage_signal

func _ready() -> void:
	change_weapon("gatling")
	
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
	if body.has_method("collect"):
		var gem: Gem = body.collect()
		print("gem", gem.cost)
		gem_count += gem.cost
		$Count.text = '+'+str(gem.cost)
		$Count.visible = true
		$CountTimer.start()
		wallet.add_child(gem)
		

func handle_buy(price: int) -> void:
	wallet.get_children().sort_custom(custom_array_sort)
	for child in wallet.get_children():
		print(child)
	pass
	
func custom_array_sort(a : int, b: int) -> bool:
	if typeof(a) == typeof(b):
		return a < b;
	return false
	
func receive_damage() -> void:
	current_health -=1
	decrease_bubble_size()
	if current_health <= 0:
		kill_player()
	pass

func kill_player() -> void:
	SceneTransition.change_scene("res://menu/Kill Player.tscn")
	#queue_free()
	pass

func decrease_bubble_size() -> void:
	enemy_push_after_damage_signal.emit(1.5)
	var scale_decrease = 1.5
	$"Collision (CollisionShape2D)2".scale /= scale_decrease
	$Area2D/CollisionShape2D.scale /= scale_decrease
	$AnimatableBody2D/CollisionPolygon2D.scale /= scale_decrease
	$Sprite2D.scale /= scale_decrease
	$"Sprite (Sprite2D)".scale /= scale_decrease
	pass

func _on_timer_timeout() -> void:
	if mission_target != null:
		nav.target_position = mission_target.position
		nav.get_next_path_position()
		if nav.get_current_navigation_path().size() > 3:
		#next_mission_direction = nav.get_current_navigation_path(3)
			next_mission_direction = to_global((nav.get_current_navigation_path().get(3) - position))
			
			
func open_upgrade_screen(cards: Array[UpgradeCard.CardClass], func_callable: Callable):
	get_tree().paused = true
	upgrade_screen.visible = true
	upgrade_screen.clear_card()
	for card in cards:
		var card_instans = preload("res://upgrade cards/UpgradeCard.tscn").instantiate()
		card_instans.init(card)
		upgrade_screen.add_card(card_instans);
	func_callable.call(self)

func _on_upgrade_screen_pick_card(card: UpgradeCard.CardClass) -> void:
	if card.func_callable != null:
		card.func_callable.call(self, card.card_args)
	upgrade_screen.visible = false
	get_tree().paused = false
	

func _on_setting_button_pressed() -> void:
	var scene_setting = preload("res://setting/Control.tscn")
	var scene =  scene_setting.instantiate()
	scene.set_scale(Vector2(0.75, 0.75))
	scene.set_position(Vector2(-190,-135))
	scene.set_z_index(12)
	add_child(scene)
	get_tree().paused = true
	
	#$Settings.visible = true
	#get_tree().paused = true


func _on_count_timer_timeout() -> void:
	$Count.visible = false


func _on_close_pressed() -> void:
	SceneTransition.change_scene("res://menu/menu.tscn")
