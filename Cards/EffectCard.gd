extends Node

var ap
var possessor
var locked = false
var consumable_player_card_class
var consumable_monster_card_class
var played = false

func _ready():
		consumable_player_card_class = load("res://Cards/PlayerConsumableCard.tscn")
		consumable_monster_card_class = load("res://Cards/MonsterConsumableCard.tscn")

############
# Effects
############

class Effect:
	const effect_names = [
		# Player
		"consume",
		"create_heal_card",
		"create_bleed_card",
		"create_wound_card",
		"defensive_exhaustion",
		"draw_card",
		"gain_attack_or_defense",
		"offensive_exhaustion",
		"overpower",
		
		# Monsters
		"heal_ally",
		"reduce_player_attack",
		"reduce_player_defense",
		
		# Both
		"first_strike",
		"gain_attack",
		"gain_defense",
		"heal_self",
		"bleed",
		"bleeding",
		"retaliation",
		"slow",
		"test"
	]
	
	var name
	var strength
	
	func init(name, strength):
		
		if effect_names.find(name) == -1:
			print("Effect '", name, "' does not exist.")
			return null
		
		self.name = name
		self.strength = strength
		return self

func trigger_effect(effect, data):
	var effect_name = effect.name
	var strength = effect.strength
	
	match effect_name:
		#Player
		"consume":
			ap.play("consume")
			yield(ap, "animation_finished")
			possessor.deck.remove_card(self)
		"create_heal_card":
			var card 
			if possessor == Player:
				card = consumable_player_card_class.instance()
			else:
				card = consumable_monster_card_class.instance()
			card.init("heal_self", strength)
			card.possessor = possessor
			possessor.deck.shuffle_card_to(card, possessor.deck.draw_pile)
		"create_bleed_card":
			Player.deck.ui.board.set_target()
			yield(Player, "target_selected")
			var card 
			if possessor == Player:
				card = consumable_monster_card_class.instance()
			else:
				card = consumable_player_card_class.instance()
			card.init("bleed", strength)
			card.possessor = self.possessor.target
			card.possessor.deck.shuffle_card_to(card, card.possessor.deck.draw_pile)
			Player.target = null
		"defensive_exhaustion":
			Player.deck.ui.board.exhaust_cells("defense", strength)
		"draw_card":
			if not possessor.dead:
				possessor.draw_card()
		"gain_attack_of_defense":
			if get_parent().is_attack_cell():
				possessor.update_defense(strength)
			elif get_parent().is_defense_cell():
				possessor.update_attack(strength)
		"offensive_exhaustion":
			Player.deck.ui.board.exhaust_cells("attack", strength)
		
		#Monster
		"heal_ally":
			for monster in get_tree().get_nodes_in_group("Enemy"):
				if monster != possessor and monster.hp_current < monster.hp_max:
					monster.update_hp(strength)
					break
		"reduce_player_attack":
			Player.update_attack(-strength)
		"reduce_player_defense":
			Player.update_defense(-strength)
		"retaliation":
			if data.has("attacker") and data.attacker != null:
				data.attacker.get_hit(null, strength)
		
		# Both
		"first_strike":
			possessor.init_current = Player.init_levels.fast
		"gain_attack":
			possessor.update_attack(strength)
		"gain_defense":
			possessor.update_defense(strength)
		"heal_self":
			possessor.update_hp(strength)
		"bleed":
			possessor.get_hit(null, strength, true)
		"test":
			print(effect_name, ": ", "Okay !")
		
		#TO COMPLETE

############
# Triggers
############

var triggers = {
	"on_draw": [],
	"on_play": [],
	"on_discard": [],
	"on_possessor_turn": [],
	"on_possessor_attacked": [],
	"on_possessor_hp_lost": [],
	"on_possessor_attack": [],
	"on_possessor_enemy_hp_lost": []
}

func trigger(data, trigger_name):
	
	print(trigger_name,", ", data)
	for effect in triggers[trigger_name]:
		trigger_effect(effect, data)

func played():
	played = true
	trigger({}, "on_play")

func enter_hand(): # Triggered in deck
	ap.play("drawn")
	yield(ap, "animation_finished")
	trigger({}, "on_draw")
	possessor.connect("start_turn", 	self, "trigger", ["on_possessor_turn"])
	possessor.connect("attacked", 		self, "trigger", ["on_possessor_attacked"])
	possessor.connect("hp_lost", 		self, "trigger", ["on_possessor_hp_lost"])
	possessor.connect("attack",			self, "trigger", ["on_possessor_attack"])
	possessor.connect("enemy_hp_lost",	self, "trigger", ["on_possessor_enemy_hp_lost"])

func exit_hand(): # Triggered in deck
	trigger({}, "on_discard")
	possessor.disconnect("start_turn", 		self, "trigger")
	possessor.disconnect("attacked", 		self, "trigger")
	possessor.disconnect("hp_lost", 		self, "trigger")
	possessor.disconnect("attack",			self, "trigger")
	possessor.disconnect("enemy_hp_lost",	self, "trigger")