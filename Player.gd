extends Node

const DRAW_CARDS_NUMBER = 5

var nick = "Player"
var hp_max = 10
var hp_current = hp_max
var init = 3

var boons = []
var banes = []

export var base_deck_path = "res://Cards/Base player deck.json"
var deck = preload("res://Deck.gd").new()
var hand_ui
var board_ui
var arrow_ui

var can_attack = false
var target = null

var attack = 0
var defense = 0

signal target_selected
signal hp_updated

func _ready():
	var file = File.new()
	file.open(base_deck_path, file.READ)
	var deck_data = parse_json(file.get_as_text())
	deck.init(deck_data)
	deck.owner = self
	file.close()

func draw_cards():
	draw(DRAW_CARDS_NUMBER)

func draw(number_of_cards):
	for i in range (number_of_cards):
		deck.draw()

func calculate_attack_and_defense():
	attack = board_ui.totalAtk
	defense = board_ui.totalDef

func set_target(tar):
	target = tar
	emit_signal("target_selected")

func attack():
#	print("Player hit ", target.name, " for ", Player.board_ui.totalAtk, "damages.")
	target.get_hit(Player.board_ui.totalAtk)

func get_hit(damages):
	if defense >= damages:
		update_defense(-damages)
		return false
	else:
		var d = damages
		d -= defense
		update_defense(-defense)
		update_hp(-d)
		return true

func update_defense(value):
	defense += value
	board_ui.get_node("TotalDefense").text = str(defense)

func update_hp(value):
	hp_current += value
	if hp_current > hp_max:
		hp_current = hp_max
	emit_signal("hp_updated")