extends BubbleGem

func collect():
	super.collect()
	if gem:
		return gem.instantiate()
