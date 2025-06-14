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

func _on_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * 1.2, 0.3)

func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.3)
	

var flag = false

func _process(delta: float) -> void:
	if $".".is_hovered() and $"Sound button/SoundRate".time_left == 0 and !flag:
		$"Sound button".play()
		$"Sound button/SoundRate".start()
		flag = true
	if !$".".is_hovered() and flag:
		$"Sound button/SoundRate".stop()
		flag = false
