extends TextureRect

var CARD_CLASS = preload("res://Card.tscn")
var type
var number

var linked_cell

signal card_added

func can_drop_data(pos, card):
	return card.type == "Versatile" or card.type == type

func drop_data(pos, card):
	card.get_parent().remove_child(card)
	add_child(card)
	card.rect_position = Vector2(0, 0)
	
	emit_signal("card_added")

func calculate_value():
	if !has_card(): return 0
	
	return get_card().main_value

func get_card():
	return get_children()[0]

func has_card():
	return get_child_count() > 0