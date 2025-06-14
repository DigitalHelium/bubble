extends BubbleGem

func collect():
	super.collect()
	if gem != null:
		return gem.instantiate()
	else:
		print("kkkk")
