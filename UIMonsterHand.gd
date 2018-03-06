extends Container

var deck

func _ready():
	get_parent().deck.ui = self
	deck = get_parent().deck

func draw_card(card):
	add_child(card)
	card.played()

func discard_card(card):
	remove_child(card)