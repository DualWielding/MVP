extends Control

var deck
onready var board = $Board
onready var hand = $Hand

func _ready():
	Player.deck.ui = self
	deck = Player.deck

func draw_card(card):
	$Hand.add_child(card)

func discard_card(card):
	$Hand.remove_child(card)