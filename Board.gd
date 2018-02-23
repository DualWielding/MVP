extends GridContainer

func _ready():
	var children = get_children()
	for i in range(children.size()):
		if i < 5:
			children[i].type = "Attack"
		else:
			children[i].type = "Defense"

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
