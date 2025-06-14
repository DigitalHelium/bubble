extends Node2D

var cards: Array[UpgradeCard.CardClass] = [
	UpgradeCard.CardClass.new('Чаще!!!', 'Уменьшить задержку на 20%', change_property, { 'duration_shot_fire': 0.8 }),
	UpgradeCard.CardClass.new('Медленее!!', 'Уменьшить ускорение движения персонажа на 20%', change_property, { 'acceleration': 0.8 }),
	UpgradeCard.CardClass.new('Друзья!', 'Уменьшить "испуг" от пузырьков на 20%', change_property, { 'particle_damage': 0.8 }),
	UpgradeCard.CardClass.new('(Не влияет)', 'Уменьшить число выпускаемых пузырьков на 20%', change_property, { 'spread_amount': 0.8 }),
	UpgradeCard.CardClass.new('RELOAD', 'Уменьшить перезарядку на 20%', change_property, { 'reload_time': 0.8 }),
	UpgradeCard.CardClass.new('Реже!!!', 'Увеличить задержку на 20%', change_property, { 'duration_shot_fire': 1.2 }),
	UpgradeCard.CardClass.new('Быстрее!!', 'Увеличить ускорение движения персонажа на 20%', change_property, { 'acceleration': 1.2 }),
	UpgradeCard.CardClass.new('Пугающе!', 'Увеличить "испуг" от пузырьков на 20%', change_property, { 'particle_damage': 1.2 }),
	UpgradeCard.CardClass.new('(Не влияет х2)', 'Увеличить число выпускаемых пузырьков на 20%', change_property, { 'spread_amount': 1.2 }),
	UpgradeCard.CardClass.new('пупупуу', 'Увеличить перезарядку на 20%', change_property, { 'reload_time': 1.2 }),
	UpgradeCard.CardClass.new('Дробаш!!', 'Взять дробовик', change_gun, {'name':'shotgun'}),
	UpgradeCard.CardClass.new('Страдания', 'Взять пистолет', change_gun, {'name':'pistol'})
]

@export var next_upgrade_price = 3
@export var next_coast = 5
@export var gem_for_win = 126
@export var current_gems = 0

func _ready() -> void:
	$Price.text = str(next_upgrade_price)
	$NotStandard.text = "Не по ГОСТу!\nНужно ещё самоцветов: %s" % [str(next_upgrade_price)]
	$NotStandard.visible = false
	$Cloud.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method('open_upgrade_screen') && next_upgrade_price <= body.gem_count:
		if (current_gems + body.gem_count) >= gem_for_win:
			SceneTransition.change_scene("res://menu/WinPlayer.tscn")
			DisplayServer.cursor_set_custom_image(null, 0, Vector2(0,0))
			return
		var arr: Array[UpgradeCard.CardClass] = [cards.pick_random(), cards.pick_random(), cards.pick_random()]
		body.open_upgrade_screen(arr, buy)
	elif body is BubbleCharacter:
		$NotStandard.text = "Не по ГОСТу!\nНужно ещё самоцветов: %s" % [str(next_upgrade_price - body.gem_count)]
		$NotStandard.visible = true
		$Cloud.visible = true
		await get_tree().create_timer(3).timeout
		$NotStandard.visible = false
		$Cloud.visible = false
		
func change_gun(player: BubbleCharacter, properties: Dictionary):
	if properties.name != null:
		player.change_weapon(properties.name)

func change_property(player: BubbleCharacter, properties: Dictionary):
	for property in properties:
		player.current_gun[property] = player.current_gun[property] * properties[property]

func buy(player: BubbleCharacter):
	if player.gem_count < next_upgrade_price:
		return
	#var price = 0
	#var i = 0;
	#while i < player.wallet.get_children().size() and price < next_upgrade_price:
		#price += player.wallet.get_children().get(i).cost
		#print(i, '/', player.wallet.get_children().size(), ' ', player.wallet.get_children().get(i).cost, ' ', price)
		#player.wallet.get_children().get(i).queue_free()
		#i += 1
	player.handle_buy(next_upgrade_price)
	next_upgrade_price += next_coast
	current_gems += next_upgrade_price
	$Price.text = str(next_upgrade_price)
	print(player.gem_count)
