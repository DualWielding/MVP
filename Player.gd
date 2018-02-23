extends Node

const DRAW_CARDS_NUMBER = 5

var nick = "Player"
var hp_max = 10
var hp_current = hp_max
var init = 3

var shields = 0
var swords = 0

var deck = preload("res://Deck.gd").new()

signal finished

func _ready():
	deck.init()
	deck.player = self

func draw_cards():
	draw(DRAW_CARDS_NUMBER)
	emit_signal("finished")

func draw(number_of_cards):
	for i in range (number_of_cards):
		deck.draw()

func attack(mob):
	pass

func hit(mob):
	pass