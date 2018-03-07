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
	
	if main_effect.name == "heal_self":
		$Cross.show()
	elif main_effect.name == "bleed":
		$Bleed.show()
	
	$Strength.text = str(main_effect.strength)