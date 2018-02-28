extends Node

var global_game
var MONSTER_CLASS = preload("res://Monster.tscn")

signal monster_cards_drawn
signal init_solved

func start(game, ennemies):
	global_game = game
	
	for ennemy in ennemies:
		var monster = MONSTER_CLASS.instance()
		monster.monster_name = ennemy
		global_game.get_node("Ennemies").add_child(monster)
		monster.connect("ennemy_mouse_entered", Player.arrow_ui, "snap")
		monster.connect("ennemy_mouse_exited", Player.arrow_ui, "unsnap")
	start_turn()

func start_turn():
	if Player.hp_current > 0 and global_game.get_node("Ennemies").get_child_count() > 0:
		initiate_new_turn()
		Player.draw_cards()
		draw_monster_cards("inf")
		yield(Player, "target_selected") # Managed in board, I should change that
		Player.calculate_attack_and_defense()
		draw_monster_cards("sup")
		next_turn() # Start the next turn once the init is solved
		resolve_init()
	else:
		end()

func next_turn():
	yield(self, "init_solved")
	start_turn()

func draw_monster_cards(init):
	for monster in global_game.get_node("Ennemies").get_children():
		if init == "inf" and monster.init <= Player.init \
		or init == "sup" and monster.init > Player.init:
			monster.draw_card()


func resolve_init():
	var init = {}
	init[Player.init] = [Player]
	for ennemy in global_game.get_node("Ennemies").get_children():
		if init.has(ennemy.init):
			init[ennemy.init].append(ennemy)
		else:
			init[ennemy.init] = [ennemy]
	
	var init_values = init.keys()
	init_values.sort()
	init_values.invert()
	
	for init_value in init_values:
		for character in init[init_value]:
			if character.hp_current > 0:
				character.attack()
	
	emit_signal("init_solved")

func initiate_new_turn():
	for ennemy in global_game.get_node("Ennemies").get_children():
		ennemy.deck.discard_all()
	
	Player.deck.discard_all()
	Player.board_ui.clear()
	Player.board_ui.refresh_totals()
	Player.attack = 0
	Player.defense = 0
	Player.target = null
	Player.can_attack = false
	Player.arrow_ui.reset()

func end():
	get_parent().next_fight()