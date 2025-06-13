class_name BubbleGem extends RigidBody2D

@export var gem: PackedScene

func collect():
	queue_free()
