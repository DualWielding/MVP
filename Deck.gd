extends Node

var possessor

var hand = []
var draw_pile = []
var discard_pile = []

var ui

func init(possessor, deck_data, card_type):
	self.possessor = possessor
	var card
	for card_data in deck_data:
		for i in range(card_data.number):
			card = card_type.instance()
			card.possessor = possessor
			card.init(card_data)
			add_card(card, "draw_pile")
	shuffle()

# Used only to add new cards to the deck, not to pass cards from one pile to another
func add_card(card, to):
	match to:
		"draw_pile":
			draw_pile.append(card)
		"discard_pile":
			discard_pile.append(card)
		"hand":
			add_to_hand(card)

func remove_card(card):
	var spots = [draw_pile, hand, discard_pile]
	for spot in spots:
		for c in spot:
			if c == card:
				spot.remove(spot.find(card))
				card.queue_free()

##############
# Draw pile
##############

func reset():
	while hand.size() > 0:
		draw_pile.append(hand.pop_front())
		for card in ui.hand.get_children():
			ui.discard_card(card)
	
	while discard_pile.size() > 0:
		draw_pile.append(discard_pile.pop_front())
	
	for card in draw_pile:
		if card.type == "consumable":
			remove_card(card)
	
	shuffle()

func shuffle(array = draw_pile):
	var current_index = array.size() - 1
	var temporary_value
	var random_index
	
	while current_index > 0:
		randomize()
		random_index = randi() % (current_index + 1)
		
		temporary_value = array[current_index]
		array[current_index] = array[random_index]
		array[random_index] = temporary_value
		
		current_index -= 1

func refill_draw_pile():
	draw_pile = discard_pile
	discard_pile = []
	shuffle()

##############
# Hand
##############

func draw():
	if draw_pile.empty():
		refill_draw_pile()
	var card = draw_pile.pop_front()
	add_to_hand(card)

func add_to_hand(card):
	hand.append(card)
	ui.draw_card(card)
	card.enter_hand() # Enables the card triggers


##############
# Discard pile
##############

func discard_hand():
	while hand.size() > 0:
		var card = hand[0]
		discard(hand, card)

# You can discard from both your hand and the draw pile
func discard(from, card):
	from.remove(from.find(card))
	if possessor == Player:
		card.locked = false
	discard_pile.append(card)
	
	# Card can be either in hand or in cell
	if from == hand:
		card.exit_hand() # Disable the card triggers
		ui.discard_card(card)

##############
# Discard and Draw piles
##############

func shuffle_card_to(card, to):
	randomize()
	if to.size() == 0:
		to.append(card)
	else:
		var place = randi() % to.size()
		to.insert(place, card)