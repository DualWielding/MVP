extends "res://Character.gd"

const CARD_CLASS = preload("res://Cards/MonsterCard.tscn")

var monster_name

signal ennemy_mouse_entered(ennemy)
signal ennemy_mouse_exited
signal target_selected
signal selected(enemy)

func _ready():
	target = Player
	
	# Generate the sprite
	var sprite = load(str("res://", monster_name, ".tscn"))
	$MobSprite.add_child(sprite.instance())
	
	# Create the deck
	var file = File.new()
	file.open(str("res://Ennemies/", monster_name, ".json"), file.READ)
	
	var stats = parse_json(file.get_as_text())
	attack_base = stats.attack
	defense_base = stats.defense
	hp_current = stats.hp
	hp_max = stats.hp
	
	init_labels()
	
	deck.init(self, stats.deck, CARD_CLASS)
	file.close()
	
	connect("selected", Player, "set_target", [self])

func init_labels():
	$Name.text = monster_name
	update_hp(0)
	reset_attack()
	reset_defense()

func _on_BackGround_mouse_entered():
	emit_signal("ennemy_mouse_entered", self)

func _on_BackGround_mouse_exited():
	emit_signal("ennemy_mouse_exited")

func _on_BackGround_gui_input( event ):
	if  Player.can_attack \
	and event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		emit_signal("selected")

##############
# UI related
##############

func ui_update_draw_pile():
	$UIMonsterDrawPile.text = str(deck.draw_pile.size())

func ui_update_discard_pile():
	pass

func ui_update_defense():
	$VBoxContainer/Defense.text = str("Def : ", defense_current)
	$VBoxContainer/Defense.hint_tooltip = str(defense_base, " + ", defense_current - defense_base)

func ui_update_attack():
	$VBoxContainer/Attack.text = str("Atq : ", attack_current)
	$VBoxContainer/Attack.hint_tooltip = str(attack_base, " + ", attack_current - attack_base)

##############
# Character overload
##############

func update_hp(value):
	hp_current += value
	$VBoxContainer/HP.text = str("HP : ", hp_current)
	if hp_current <= 0:
		die()

func die():
	dead = true
	Player.current_fight.check_for_end()
	get_parent().remove_child(self)
	for card in deck.hand:
		card.queue_free()
	deck.queue_free()
	queue_free()