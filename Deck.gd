extends Node

var hand = []
var draw_pile = []
var discard_pile = []

var player

signal card_added_to_hand(card)

func init():
	var dir_path = "res://Cards/Tier 0"
	var dir = Directory.new()
	dir.open(dir_path)
	dir.list_dir_begin()
	
	while true:
		var file = File.new()
		var file_name = dir.get_next()
		if file_name == "":
			break
		elif not file_name.begins_with("."):
			file.open(str(dir_path, "/", file_name), file.READ)
			draw_pile.append(parse_json(file.get_as_text()))
			file.close()
	
	shuffle()

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