extends Control

const fights_path = "res://Fights/Fights.json"
const FIGHT_CLASS = preload("res://Fight.gd")
const CARD_CLASS = preload("res://Card.tscn")

var fights
var current_fight
var current_fight_index = 0

func _ready():
	# Generate the fights order
	var file = File.new()
	file.open(fights_path, file.READ)
	fights = parse_json(file.get_as_text())
	file.close()
	
	Player.hand_ui = $Hand
	Player.arrow_ui = $Arrow
	Player.deck.connect("card_added_to_hand", self, "add_card_to_hand")
	new_fight()

func next_fight():
	remove_child(current_fight)
	current_fight_index += 1
	if current_fight_index > fights.size():
		get_tree().quit()
	else:
		new_fight()

func new_fight():
	Player.deck.reset()
	Player.update_hp(Player.hp_max - Player.hp_current)
	current_fight = FIGHT_CLASS.new()
	current_fight.start(self, fights[current_fight_index])
	add_child(current_fight)

func add_card_to_hand(card_data):
	var card = CARD_CLASS.instance()
	card.init(card_data)
	$Hand.add_child(card)