extends Control

#enum LOCATIONS {
#	discard_pile,
#	draw_pile,
#	hand
#}
#
#var 
#
#var location = LOCATIONS.draw_pile

var CARD_CLASS = preload("res://Card.tscn")

var type
var chain_top = 0
var chain_bot = 0
var main_value = 0

var bonuses
var penalties
var card_name
var initial_data

func init(dict):
	initial_data = dict
	
	card_name = dict.name
	type = dict.type
	main_value = dict.value
	chain_top = dict.chain_top
	chain_bot = dict.chain_bot
	bonuses = dict.bonuses
	penalties = dict.penalties
	return self

func _ready():
	$Background/Name.text = card_name
	
	if type == "Attack":
		$Background/Sword.show()
	elif type == "Defense":
		$Background/Shield.show()

	$"Background/SE-Top".text = str(chain_top)
	$"Background/SE-Bot".text = str(chain_bot)
	$"Background/Value".text = str(main_value)

	var bonus_str = ""
	for bonus in bonuses:
		bonus_str = str(bonus_str, bonus, "\n")

	var penalties_str = ""
	for penalty in penalties:
		penalties_str = str(penalties_str, penalty, "\n")

	$"Background/Bonus-Penalties".text = str(bonus_str, penalties_str)

# Drag and Drop
func get_drag_data(pos):
	var card = CARD_CLASS.instance()
	card.init(initial_data)
	card.rect_scale = Vector2(0.5, 0.5)
	set_drag_preview(card)
	return self