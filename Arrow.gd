extends TextureRect

var fixed_end = false
var start = Vector2()
var end = get_local_mouse_position()

func _draw():
	var curve = Curve2D.new()
	curve.add_point(start, Vector2(), Vector2(150, -300))
	curve.add_point(end)
	
	draw_polyline(curve.tessellate(), Color(1, 0, 0), 2.0, true)

func snap(ennemy):
	if Player.target != null and Player.target != ennemy: return
	var bg = ennemy.get_node("BackGround")
	fixed_end = true
	# Bicoz of rotation in the enemy BG it becomes insane !
	end = Vector2(bg.rect_global_position.x - rect_global_position.x - bg.rect_size.x/2, bg.rect_global_position.y - rect_global_position.y + bg.rect_size.y/4)

func unsnap():
	if Player.target != null: return
	fixed_end = false

func _process(delta):
	if !fixed_end:
		end = get_local_mouse_position()
	update()

func _ready():
	set_process(true)

func reset():
	fixed_end = false
	hide()