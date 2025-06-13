extends Node2D

var cards: Array[UpgradeCard.CardClass] = [
	UpgradeCard.CardClass.new('card 1', 'Уменьшить задержку на 20%', change_property, { 'duration_shot_fire': 0.8 }),
	UpgradeCard.CardClass.new('shotgun!!', 'Взять shotgun', change_gun, {'name':'shotgun'}),
	UpgradeCard.CardClass.new('pistol', 'Взять pistol', change_gun, {'name':'pistol'})
]

@export var next_upgrade_price = 3
@export var next_coast = 5

func _ready() -> void:
	$Price.text = str(next_upgrade_price)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method('open_upgrade_screen') && next_upgrade_price <= body.gem_count:
		body.open_upgrade_screen(cards, buy)
		
func change_gun(player: BubbleCharacter, properties: Dictionary):
	if properties.name != null:
		player.change_weapon(properties.name)

func change_property(player: BubbleCharacter, properties: Dictionary):
	for property in properties:
		player.current_gun[property] = player.current_gun[property] * properties[property]

func buy(player: BubbleCharacter):
	if player.gem_count < next_upgrade_price:
		return
	var price = 0
	var i = 0;
	while i < player.wallet.get_children().size() and price < next_upgrade_price:
		price += player.wallet.get_children().get(i).cost
		print(i, '/', player.wallet.get_children().size(), ' ', player.wallet.get_children().get(i).cost, ' ', price)
		player.wallet.get_children().get(i).queue_free()
		i += 1
	player.gem_count -= price
	next_upgrade_price += next_coast
	$Price.text = str(next_upgrade_price)
	print(player.gem_count)
