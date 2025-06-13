class_name UpgradeCard extends Button

class CardClass extends Node:
	var card_label: String = ""
	var description: String = ""
	var card_args: Dictionary = {}
	var func_callable: Callable
	
	func _init(label: String, desc: String, callable: Callable, args: Dictionary):
		card_label = label
		description = desc
		card_args = args
		func_callable = callable

signal pick_card(card: UpgradeCard.CardClass)

var card

func init(card_impl: CardClass):
	card = card_impl
	$Label.text = card_impl.card_label
	$Description.text = card_impl.description

func _on_pressed() -> void:
	pick_card.emit(card)
