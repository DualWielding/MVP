extends Node

enum init_levels {
	slow,
	normal,
	fast
}

var deck = preload("res://Deck.gd").new()

var hp_max = 10
var hp_current = hp_max

var init_base = init_levels.normal
var init_current = init_base
var attack_base = 0
var attack_current = attack_base
var defense_base = 0
var defense_current = defense_base

var target
var dead = false

# UI related signals
#signal hp_updated
#signal defense_updated
#signal attack_updated

# Cards-related signals
signal start_turn(data)
signal attacked(data)
signal hp_lost(data)
signal attack(data)
signal enemy_hp_lost(data)

##############
# Deck
##############

func draw_card():
	deck.draw()

##############
# Fight
##############

func start_turn():
	emit_signal("start_turn", {})
	attack()

func attack():
	emit_signal("attack", {"target": target})
	var damages = attack_current
	if damages < 0: damages = 0
	var hp_lost_number = target.get_hit(self, damages)
	if hp_lost_number > 0:
		emit_signal("enemy_hp_lost", {"target": target, "hp_lost": hp_lost_number})

func get_hit(attacker, damages, true_damage = false):
	emit_signal("attacked", {"attacker": attacker})
	var hp_lost = 0
	if !true_damage and defense_current >= damages:
		update_defense(-damages)
	else:
		hp_lost = damages
		if !true_damage:
			hp_lost -= defense_current
			update_defense(-defense_current)
		update_hp(-hp_lost)
		emit_signal("hp_lost", {"attacker": attacker, "hp_lost": hp_lost})
	return hp_lost

func update_hp(value):
	hp_current += value
	if hp_current > hp_max:
		hp_current = hp_max
	elif hp_current <= 0:
		die()
	ui_update_hp()

func reset_hp():
	hp_current = hp_max
	ui_update_hp()

func ui_update_hp():
	pass

func update_defense(value):
	defense_current += value
	ui_update_defense()

func reset_defense():
	defense_current = defense_base
	ui_update_defense()

func ui_update_defense():
	pass

func update_attack(value):
	attack_current += value
	ui_update_attack()

func reset_attack():
	attack_current = attack_base
	ui_update_attack()

func ui_update_attack():
	pass

func update_init(init_level):
	init_current = init_level

func reset_init():
	init_current = init_base

func ui_update_discard_pile():
	pass

func ui_update_draw_pile():
	pass

func die():
	queue_free()