extends "res://Cards/PlayerCard.gd"

func _ready():
	ap = $AnimationPlayer
	$Background/Labels/Name.text = card_name
	
	var effect_name = "gain_attack_or_defense"
	if type == "attack":
		$Background/Sword.show()
		effect_name = "gain_attack"
	elif type == "defense":
		$Background/Shield.show()
		effect_name = "gain_defense"
	
	for effect in triggers.on_play:
		if effect.name == effect_name:
			$Background/Labels/Value.text = str(effect.strength)
	
	var triggers_str = ""
	for trigger_name in triggers.keys():
		for effect in triggers[trigger_name]:
			if effect.name != "gain_attack" \
			and effect.name != "gain_defense" \
			and effect.name != "gain_attack_or_defense":
				triggers_str = str(triggers_str, effect.name, "(", effect.strength, ")\n")
	
	$Background/Labels/Effects.text = triggers_str