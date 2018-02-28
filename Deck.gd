extends Node

var hand = []
var draw_pile = []
var discard_pile = []

signal card_added_to_hand(card)

func init(deck_data):
	for card in deck_data:
		for i in range(card.number):
			draw_pile.append(card)
	shuffle()

func reset():
	while hand.size() > 0:
		draw_pile.append(hand.pop_front())
	
	while discard_pile.size() > 0:
		draw_pile.append(discard_pile.pop_front())
	
	shuffle()

func add_card(card, to):
	match to:
		"draw_pile":
			draw_pile.append(card)
		"discard_pile":
			discard_pile.append(card)
		"hand":
			add_to_hand(card)

func discard_all():
	while hand.size() > 0:
		discard_pile.append(hand.pop_front())

func draw():
	if draw_pile.empty():
		refill_hand()
	var card = draw_pile.pop_front()
	add_to_hand(card)

func add_to_hand(card):
	hand.append(card)
	emit_signal("card_added_to_hand", card)

func refill_hand():
	draw_pile = discard_pile
	discard_pile = []
	shuffle()

func shuffle(array = draw_pile):
	var current_index = array.size() - 1
	var temporary_value
	var random_index
	
	while current_index > 0:
		randomize()
		random_index = rand_range(0, current_index)
		
		temporary_value = array[current_index]
		array[current_index] = array[random_index]
		array[random_index] = temporary_value
		
		current_index -= 1