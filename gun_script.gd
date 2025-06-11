class_name Gun extends Node2D

var button_time_held = 0.0

signal fire_signal

enum GUN_TYPE {AUTOMATIC = 1, SHOTGUN = 10}
# var GunChild gun
@export var automatic_acceleration : float = 30.0
@export var shotgun_acceleration : float = 100.0

### Делаю, чтобы когда проходило время зажатия кнопки, 
### пушка определенного типа вызывала ивент выстрела, 
### который будет отлавливаться в скрипте персонажа и через метод изменять ускорение текущее

func _ready():
	var parent : BubbleCharacter = get_parent()
	fire_signal.connect(parent.handle_fire_event)
	
func calc_held_time(delta: float, button_time_held: float) -> float:
	return button_time_held - delta


func check_if_shot_fired(button_time_held: float, type: GUN_TYPE) -> float:
		
	if type == GUN_TYPE.AUTOMATIC and button_time_held < 0:
		fire_signal.emit(automatic_acceleration)
		return 0.1
	if type == GUN_TYPE.SHOTGUN and button_time_held < 0:
		fire_signal.emit(shotgun_acceleration)
		return 1.5
	return button_time_held

func abstract_check_fire() -> void:
	return

func _physics_process(delta) -> void:
	button_time_held = clamp(calc_held_time(delta, button_time_held), -1, 1)
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up"):
		button_time_held = check_if_shot_fired(button_time_held, GUN_TYPE.SHOTGUN)

	
	
