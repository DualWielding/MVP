extends TextureRect

var CARD_CLASS = preload("res://Card.tscn")
var type

func can_drop_data(pos, card):
	return card.type == "Versatile" or card.type == type

func drop_data(pos, card):
	card.get_parent().remove_child(card)
	add_child(card)
	card.rect_position = Vector2(0, 0)