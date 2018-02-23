extends Control

const FIGHT_CLASS = preload("res://Fight.gd")
const CARD_CLASS = preload("res://Card.tscn")

var fight

func _ready():
	Player.deck.connect("card_added_to_hand", self, "refresh_hand")
	fight = FIGHT_CLASS.new()
	fight.start()

func refresh_hand(card_data):
	var card = CARD_CLASS.instance()
	card.init(card_data)
	$Hand.add_child(card)