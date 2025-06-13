class_name DecreaseScript extends Node2D

@onready var character : BubbleCharacter

func _ready():
	character.change_bubble_after_damage_signal.connect(decrease_scale)
	
func decrease_scale(decrease_factor: float):
	self.scale /= decrease_factor
