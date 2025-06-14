class_name SpawnEnemies extends Node

@onready var player : BubbleCharacter = $"../Character (main_bubble)"
@onready var camera : Camera2D = $"../Character (main_bubble)/Camera2D"
@onready var map : TileMapLayer = $"../TileMapLayer"

var success_create = false

var enemy_scene = preload("res://enemy_scene.tscn")
@export var enemy_count = 0
@export var enemy_count_max = 4

func _on_timer_timeout() -> void:
	if enemy_count > enemy_count_max or !is_instance_valid(player):
		return
	var spawn_position = calculate_spawn_position()
	if !success_create :
		print("fail create enemy")
		return
	var enemy = enemy_scene.instantiate()
	enemy.set_target(player)
	enemy.set_current_target_position(player.position)
	enemy.position = spawn_position
	enemy_count = enemy_count + 1
	enemy.enemy_died.connect(enemy_died_handler)
	add_child(enemy)

func calculate_spawn_position() -> Vector2:
	var size = get_viewport().get_visible_rect().size
	var x = 0
	var y = 0
	var count_try = 0
	success_create = false
	while count_try < 10 and !success_create :
		x = (size.x + randi_range(50, 150)) / 32 * randi_range(-1, 1)
		y = (size.y + randi_range(50, 150)) / 32 * randi_range(-1, 1)
		if check_spawn_place(Vector2i(roundi(x), roundi(y))):
			success_create = true
		count_try += 1
	if count_try == 10:
		success_create = true
		return Vector2(0, 0)
	return Vector2(roundi(x * 32), roundi(y * 32))

func check_spawn_place(position : Vector2i) -> bool:
	if map.get_cell_tile_data(position) == null :
		return false
	var position_cells = map.get_surrounding_cells(position)
	position_cells.append(position)
	var temp_positions : Array[Vector2i] = []
	for pos in position_cells :
		temp_positions.append_array(map.get_surrounding_cells(pos))
	position_cells.append_array(temp_positions)
	
	for pos in position_cells :
		var cell = map.get_cell_tile_data(position)
		if cell != null and cell.get_collision_polygons_count(0) > 0:
			return false
	return true

func enemy_died_handler(enemy : Enemy) -> void:
	enemy_count = enemy_count - 1


func _on_timer_max_enemy_timeout() -> void:
	enemy_count_max = enemy_count_max + 1
