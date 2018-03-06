extends Node

#Player only spells

var CARD_CLASS = preload("res://Card.tscn")

func cast(params):
	match params.name:
		"Heal":
			var heal_card = CARD_CLASS.new()
			heal_card.effects.on_draw.append(Effects.create("Heal", Player, params.strength))
			heal_card.effects.on_draw.append(Effects.create("Draw", Player, 1))
			Player.deck.shuffle_card_to(heal_card, deck.draw_pile)
		"Ignite":
			pass
		"Draw":
			pass
		"Consumable":
			pass
#		"Wound":
#			if enemy == Player:
#				for i in range(params.strength):
#					var wound = CARD_CLASS.new()
#					wound.init({ 
#						name = "Wound",
#						type = "Versatile",
#						chain_top = 0,
#						chain_bot = 0,
#						value = 0,
#						bonuses = [],
#						penalties = [] 
#					})
#					var location
#					if caster.init > enemy.init:
#						location = "draw_pile"
#					else:
#						location = "discard_pile"
#					enemy.deck.add_card(wound, location)
#
#		"Reduce defense":
#				enemy.defense -= params.strength
#		"Reduce attack":
#				enemy.attack -= params.strength
#		"Boost init":
#			caster.add_boon
#		"Retribution":
#			pass
#		"Heal ally":
#			pass
#		"Heal self":
#			pass

static func heal(strength):
	Player.update_hp(strength)