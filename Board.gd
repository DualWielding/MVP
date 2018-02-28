extends Control

var totalAtk = 0
var totalDef = 0

func _ready():
	Player.board_ui = self
	Player.connect("hp_updated", self, "show_hp")
	show_hp() # Since the player is loaded before his Board
	
	var children = $Cells.get_children()
	for i in range(children.size()):
		var cell = children[i]
		if i < 5:
			cell.type = "Attack"
			if i < 4:
				cell.linked_cell = children[i + 5]
			else:
				cell.linked_cell = null
		else:
			cell.type = "Defense"
			cell.linked_cell = children[i - 5]
	
		cell.connect("card_added", self, "refresh_totals")
		cell.connect("card_added", self, "check_for_attack")

func clear():
	for cell in $Cells.get_children():
		for card in cell.get_children():
			cell.remove_child(card)

func show_hp():
	$HP.text = str("HP : ", Player.hp_current)

func refresh_totals():
	totalAtk = 0
	totalDef = 0
	
	for cell in $Cells.get_children():
		if cell.type == "Attack":
			totalAtk += cell.calculate_value()
		elif cell.type == "Defense":
			totalDef += cell.calculate_value()
	
	$TotalAttack.text = str(totalAtk)
	$TotalDefense.text = str(totalDef)

func check_for_attack():
	if Player.hand_ui.get_child_count() == 0:
		set_attack()
	else:
		unset_attack()

func unset_attack():
	Player.arrow_ui.hide()
	Player.target = null
	Player.arrow_ui.unsnap()
	Player.can_attack = false

func set_attack():
	Player.arrow_ui.show()
	Player.can_attack = true