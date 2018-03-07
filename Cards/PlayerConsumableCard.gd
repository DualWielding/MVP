extends "res://Cards/EffectCard.gd"

var main_effect # For convenience, also in on_draw
var type = "consumable"

func init(main_effect_name, main_effect_strength):
	
	main_effect = Effect.new() .init(main_effect_name, main_effect_strength)
	
	# Add effects
	triggers.on_draw.append(main_effect)
	triggers.on_draw.append(Effect.new().init("consume", 1))
	triggers.on_draw.append(Effect.new().init("draw_card", 1))

func _ready():
	ap = $AnimationPlayer
	
	$Background/Labels/Name.text = main_effect.name
	
	if main_effect.name == "heal_self":
		$Background/Cross.show()
	elif main_effect.name == "bleed":
		$Background/Flame.show()
	
	$Background/Labels/Value.text = str(main_effect.strength)
	
	var triggers_str = ""
	for trigger_name in triggers.keys():
		for effect in triggers[trigger_name]:
			if effect != main_effect:
				triggers_str = str(triggers_str, effect.name, "(", effect.strength, ")\n")
	
	$Background/Labels/Effects.text = triggers_str
	