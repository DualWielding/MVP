extends TextureRect

var type
var number

var linked_cell

var exhausted = false

signal card_added

func can_drop_data(pos, card):
	if Player.deck.ui.board.number_of_open_cells(card.type) < 2:
		for effect in card.triggers.on_play:
			if effect.name == "defensive_exhaustion" or effect.name == "offensive_exhaustion":
				return false
	return  !exhausted and (card.type == "versatile" or card.type == type)

func drop_data(pos, card):
	card.get_parent().remove_child(card)
	add_child(card)
	card.rect_position = Vector2(0, 0)
	card.played()

func is_attack_cell():
	return type == "attack"

func is_defense_cell():
	return type == "defense"

func calculate_value():
	if !has_card(): return 0
	
	return get_card().main_value

func get_card():
	return get_children()[0]

func has_card():
	return get_child_count() > 0

func exhaust():
	exhausted = true
	self_modulate = Color("#494848")

func restore():
	exhausted = false
	self_modulate = Color("#3e2727")