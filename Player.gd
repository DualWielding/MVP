extends "res://Character.gd"

const CARD_CLASS = preload("res://Cards/PlayerBoardCard.tscn")
const DRAW_CARDS_NUMBER = 5

var nick = "Player"
var current_fight

export var base_deck_path = "res://Cards/Base player deck.json"

var arrow_ui

var can_attack = false

signal target_selected
signal ready_for_attack

func _ready():
	var file = File.new()
	file.open(base_deck_path, file.READ)
	var deck_data = parse_json(file.get_as_text())
	deck.init(self, deck_data, CARD_CLASS)
	file.close()
	
	connect("defense_updated", self, "ui_update_defense")

func draw_cards(cards_number):
	for i in range(cards_number):
		draw_card()

func set_target(target):
	self.target = target
	emit_signal("target_selected")

func ready_for_attack():
	emit_signal("ready_for_attack")

##################
# UI related
##################

func ui_update_attack():
	deck.ui.get_node("Board/TotalAttack").text = str(attack_current)
	deck.ui.get_node("Board/TotalAttack").hint_tooltip = str(attack_base, " + ", attack_current - attack_base)

func ui_update_hp():
	deck.ui.get_node("Board/HP").text = str(hp_current)

func ui_update_defense():
	deck.ui.get_node("Board/TotalDefense").text = str(defense_current)
	deck.ui.get_node("Board/TotalDefense").hint_tooltip = str(defense_base, " + ", defense_current - defense_base)

###################
# Character overload
###################

func die():
	get_tree().quit()