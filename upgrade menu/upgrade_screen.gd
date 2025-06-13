extends CanvasLayer

@onready var card_container = $MarginContainer/HBoxContainer

signal pick_card(card: UpgradeCard.CardClass)

func add_card(card: UpgradeCard):
	card_container.add_child(card)
	card.pick_card.connect(Callable(self,"connected_signal"))

func clear_card():
	for card_node in card_container.get_children():
		card_container.remove_child(card_node)

func connected_signal(card: UpgradeCard.CardClass):
	pick_card.emit(card)
