extends Control

signal main_attack_target_set

func _ready():
	Player.connect("hp_updated", self, "show_hp")
	
	var children = $Cells.get_children()
	for i in range(children.size()):
		var cell = children[i]
		if i < 5:
			cell.type = "attack"
			if i < 4:
				cell.linked_cell = children[i + 5]
			else:
				cell.linked_cell = null
		else:
			cell.type = "defense"
			cell.linked_cell = children[i - 5]

func clear():
	for cell in $Cells.get_children():
		for card in cell.get_children():
			cell.remove_child(card)
		cell.restore()

func unset_target():
	Player.arrow_ui.hide()
	Player.target = null
	Player.arrow_ui.unsnap()
	Player.can_attack = false

func set_target():
	Player.arrow_ui.show()
	Player.can_attack = true
	yield(Player, "target_selected")
	Player.arrow_ui.hide()
	Player.arrow_ui.unsnap()
	Player.can_attack = false

func number_of_open_cells(type):
	var number = 0
	var start = 0
	var stop = 8
	if type == "attack":
		stop = 4
	elif type == "defense":
		start = 5
	while start <= stop:
		var cell = $Cells.get_children()[start]
		if not cell.exhausted and not cell.has_card():
			number += 1
		start += 1
	return number

func exhaust_cells(type, number):
	for i in range(number):
		exhaust_cell(type)

func exhaust_cell(type):
	var current_cell_index = 4
	var cell
	if type == "attack":
		while current_cell_index > -1:
			cell = $Cells.get_children()[current_cell_index]
			if not cell.exhausted and not cell.has_card():
				cell.exhaust()
				return
			current_cell_index -= 1
	elif type == "defense":
		current_cell_index = 8
		while current_cell_index > 4:
			cell = $Cells.get_children()[current_cell_index]
			if not cell.exhausted and not cell.has_card():
				cell.exhaust()
				return
			current_cell_index -= 1

func _on_AttackButton_pressed():
	set_target()
	yield(Player, "target_selected")
	Player.ready_for_attack()