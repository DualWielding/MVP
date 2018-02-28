extends Control

var monster_name

var attack
var defense
var hp_current
var hp_max
var init

var boons = []
var banes = []

signal ennemy_mouse_entered(ennemy)
signal ennemy_mouse_exited
signal target_selected

var deck = preload("res://Deck.gd").new()
	
func _ready():
	# Generate the sprite
	var sprite = load(str("res://", monster_name, ".tscn"))
	$MobSprite.add_child(sprite.instance())
	
	# Create the deck
	var file = File.new()
	file.open(str("res://Ennemies/", monster_name, ".json"), file.READ)
	
	var stats = parse_json(file.get_as_text())
	attack = stats.attack
	defense = stats.defense
	hp_current = stats.hp
	hp_max = stats.hp
	init = stats.init
	
	init_labels()
	
	deck.init(stats.deck)
	deck.owner = self
	
	file.close()
	
	# Link drawing a card to showing it
	deck.connect("card_added_to_hand", self, "card_drawn")

func draw_card():
	deck.draw()

func init_labels():
	$Name.text = monster_name
	update_hp(0)
	$VBoxContainer/Init.text = str("Init : ", init)
	$VBoxContainer/Attack.text = str("Atq : ", attack)
	$VBoxContainer/Defense.text = str("Def : ", defense)

func card_drawn(card):
	$DrawnCards/VBoxContainer/Attack.text = str("Attack : ", card.attack)
	$DrawnCards/VBoxContainer/Defense.text = str("Defense : ", card.defense)
	var effects_str = ""
	if card.has("effects"):
		for activator in card.effects.keys():
			for effect in card.effects[activator]:
				effects_str = str(effects_str, effect.type, "\n")
		$DrawnCards/VBoxContainer/Effects.text = effects_str

func _on_BackGround_mouse_entered():
	emit_signal("ennemy_mouse_entered", self)


func _on_BackGround_mouse_exited():
	emit_signal("ennemy_mouse_exited")

func attack():
	var card = deck.hand[0]
	var damage_dealt = Player.get_hit(attack + card.attack)
#	if damage_dealt and card.has("effects") and card.effects.has("on_damage"):
#		for effect in card.effects.on_damage:
#			Effects.cast(effect, self, Player)

func get_hit(damages):
	
	var d = damages
	d -= defense + deck.hand[0].defense
#	print(name, " defense absorb ", damages - d, " damages.")
	if d > 0:
		update_hp(-d)
#		print(name, " takes ", d, " damages.")
#		print(name, " now has ", hp_current, " HP.")
		return true
	return false

func update_hp(value):
	hp_current += value
	$VBoxContainer/HP.text = str("HP : ", hp_current)
	if hp_current <= 0:
		die()

func die():
	get_parent().remove_child(self)
	deck.queue_free()
	queue_free()

func _on_BackGround_gui_input( event ):
	if Player.can_attack \
	and event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		Player.set_target(self)
		Player.arrow_ui.snap(self)