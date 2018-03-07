extends Node

var global_game
onready var enemies = $Enemies

var MONSTER_CLASS = preload("res://Monster.tscn")

signal monster_cards_drawn
signal init_solved
signal initiated

func start(game, enemies_names):
	global_game = game
	
	for enemy_name in enemies_names:
		var monster = MONSTER_CLASS.instance()
		monster.monster_name = enemy_name
		enemies.add_child(monster)
		monster.connect("ennemy_mouse_entered", Player.arrow_ui, "snap")
		monster.connect("ennemy_mouse_exited", Player.arrow_ui, "unsnap")
	start_round()

func start_round():
	initiate_new_round()
	yield(Player, "ready_for_attack") # Managed in board, I should change that
	next_round() # Start the next turn once the init is solved
	resolve_init()

func next_round():
	yield(self, "init_solved")
	start_round()

func draw_monster_cards():
	for monster in enemies.get_children():
		monster.draw_card()

func resolve_init():
	var init_levels = [Player.init_levels.fast, Player.init_levels.normal, Player.init_levels.slow]
	for init_level in init_levels:
		if Player.init_current == init_level:
			Player.start_turn()
		for enemy in enemies.get_children():
			if enemy.init_current == init_level:
				enemy.start_turn()
	
	emit_signal("init_solved")

func initiate_new_round():
	for enemy in enemies.get_children():
		enemy.reset_attack()
		enemy.reset_defense()
		enemy.reset_init()
		enemy.deck.discard_hand()
	
	Player.deck.discard_hand()
	Player.deck.ui.get_node("Board").clear()
	Player.reset_attack()
	Player.reset_defense()
	Player.reset_init()
	Player.target = null
	Player.can_attack = false
	Player.arrow_ui.reset()
	
	Player.draw_cards(Player.DRAW_CARDS_NUMBER)
	draw_monster_cards()

func check_for_end():
	for enemy in enemies.get_children():
		if !enemy.dead: return
	end()

func end():
	get_parent().next_fight()