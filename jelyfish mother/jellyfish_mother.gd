extends Node2D

var cards: Array[UpgradeCard.CardClass] = [
	UpgradeCard.CardClass.new('card 1', 'Уменьшить задержку на 20%', change_property, { 'duration_shot_fire': 0.8 }),
	UpgradeCard.CardClass.new('shotgun!!', 'Взять shotgun', change_gun, {'name':'shotgun'}),
	UpgradeCard.CardClass.new('pistol', 'Взять pistol', change_gun, {'name':'pistol'})
]


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method('open_upgrade_screen'):
		body.open_upgrade_screen(cards)
		
func change_gun(player: BubbleCharacter, properties: Dictionary):
	if properties.name != null:
		player.change_weapon(properties.name)

func change_property(player: BubbleCharacter, properties: Dictionary):
	for property in properties:
		player.current_gun[property] = player.current_gun[property] * properties[property]
