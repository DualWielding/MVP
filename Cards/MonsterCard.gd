extends "res://Cards/EffectCard.gd"

var attack
var defense

func _ready():
	ap = $AnimationPlayer
	update_attack()
	update_defense()
	update_effects_label()

func init(card_data):
	for trigger_name in triggers.keys():
		if card_data.has(trigger_name):
			_add_effects(card_data, trigger_name, triggers[trigger_name])

func _add_effects(card_data, trigger_name, array):
	var effect_strength
	for effect_name in card_data[trigger_name].keys():
		effect_strength = card_data[trigger_name][effect_name]
		array.append(Effect.new().init(effect_name, effect_strength))

func update_attack():
	var value = 0
	for effect in triggers.on_play:
		if effect.name == "gain_attack":
			value += effect.strength
	attack = value
	$Labels/Attack.text = str("Attack : ", attack)

func update_defense():
	var value = 0
	for effect in triggers.on_play:
		if effect.name == "gain_defense":
			value += effect.strength
	defense = value
	$Labels/Defense.text = str("Defense : ", defense)

func update_effects_label():
	var triggers_str = ""
	for trigger_name in triggers.keys():
		for effect in triggers[trigger_name]:
			if effect.name != "gain_attack" \
			and effect.name != "gain_defense" \
			and effect.name != "gain_attack_or_defense":
				triggers_str = str(triggers_str, effect.name, "(", effect.strength, ")\n")
	
	$Labels/Effects.text = triggers_str