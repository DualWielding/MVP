extends "res://Cards/EffectCard.gd"

var card_name
var type

# Drag and Drop
func get_drag_data(pos):
	if locked: return null
	
	var copy = self.duplicate(true)
	copy.rect_scale = Vector2(0.5, 0.5)
	set_drag_preview(copy)
	return self

func _on_Background_gui_input( event ):
	pass
#	if !locked \
#	and get_parent().is_in_group("BoardCell") \
#	and event is InputEventMouseButton \
#	and event.button_index == BUTTON_RIGHT \
#	and event.is_pressed():
#		for effect in triggers.on_play:
#			if get_parent().type == "attack" and (effect.name == "gain_attack" or effect.name == "gain_defense_or_attack"):
#				Player.update_attack(-effect.strength)
#			elif get_parent().type == "defense" and (effect.name == "gain_defense" or effect.name == "gain_defense_or_attack"):
#				Player.update_defense(-effect.strength)
#		get_parent().remove_child(self)
#		Player.deck.ui.get_node("Hand").add_child(self)
#		Player.deck.ui.get_node("Board").unset_target()

func init(card_data):
	self.card_name = card_data.name
	type = card_data.type
	
	# Add effects
	for trigger_name in triggers.keys():
		if card_data.has(trigger_name):
			_add_effects(card_data, trigger_name, triggers[trigger_name])

func _add_effects(card_data, trigger_name, array):
	var effect_strength
	for effect_name in card_data[trigger_name].keys():
		effect_strength = card_data[trigger_name][effect_name]
		array.append(Effect.new().init(effect_name, effect_strength))