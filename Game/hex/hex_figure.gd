extends Node2D


@onready var hex_figure = $HexFigureArea
@onready var hexes = $Hexes
@export var figure_number = 0

var rng = RandomNumberGenerator.new()

# coefficient to resize figure when idle:
var idle_size_coeff = 0.65

# need to return to start position when picked down
var start_position = Vector2()
# check state
var is_inserted = false
var is_picked_up = false
# need to floating when on start position
var current_start_position = Vector2()
var idle_state = true
# need to avoid accidental isertion when flying to start position
var is_insertable = true
# explodin in the end 
var is_explodes = false
# ...
var figure_centre = Vector2()



# clip specific figure from big template
func generate_figure(hexes_numbers):
	for hex in hexes.get_children():
		if (hex.hex_number not in hexes_numbers):
			hex.free()

# just enumerate hexes
func enumerate_hexes():
	var counter = 0
	for hex in hexes.get_children():
		counter += 1
		hex.hex_number = counter
		hex.set_text(counter)


# find figure centre
func calculate_size():
	var fig_top = 10000
	var fig_bottom = -10000
	var fig_left = -10000
	var fig_right = 10000
	for hex in hexes.get_children():
		var x = hex.position.x
		var y = hex.position.y
		if x <= fig_right : fig_right = x
		if x >= fig_left : fig_left = x
		if y >= fig_bottom : fig_bottom = y
		if y <= fig_top : fig_top = y
	figure_centre = Vector2((fig_right + fig_left) / 2, (fig_bottom + fig_top) / 2)


# move new clipped figure to the centre of scene (to the start position) 
func centralize():
	calculate_size()
	var shift = hex_figure.position - figure_centre 
	for hex in hexes.get_children():
		hex.position += shift
		hex.start_position = hex.position


# check if ALL tiles inside socket
func inside_socket():
	var out = true
	for hex in hexes.get_children():
		out = (out and hex.inside_socket)
	return out
#	return (hex1.inside_socket and hex2.inside_socket and hex3.inside_socket)


# check if ANY tile inside other tile
func inside_hex():
	var out = false
	for hex in hexes.get_children():
		out = (out or hex.inside_hex)
	return out
#	return (hex1.inside_hex or hex2.inside_hex or hex3.inside_hex)

# check if ANY tile of CURENT figure is picked up
func check_is_picked_up():
	var out = false
	for hex in hexes.get_children():
		out = (out or hex.picked_up)
	return out
#	return (hex1.picked_up or hex2.picked_up or hex3.picked_up)

# insert every single hex of figure into sockets
func insert_all(delta):
	for hex in hexes.get_children():
		hex.insertion(delta)


# Called when the node enters the scene tree for the first time.
func _ready():
	HexfigureSingletone.connect("on_picked_up", _on_picked_up)
	HexfigureSingletone.connect("on_picked_down", _on_picked_down)
	# save start position
	start_position = hex_figure.position
	_on_timer_timeout()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	### when picked up
	if is_picked_up:
		var movement_shift = Vector2()
		idle_state = false
		hexes.scale = hexes.scale.move_toward(Vector2(1, 1), 4 * delta)
		for hex in hexes.get_children():
			if hex.picked_up:
				movement_shift = hex.start_position
			hex.position = hex.position.move_toward(hex.start_position + hex_figure.position, 10_000 * delta)
		hex_figure.position = hex_figure.position.move_toward(
			get_local_mouse_position() - movement_shift, 2_000 * delta
		)
	
	### if explodes
	if is_explodes:
		for hex in hexes.get_children():
			var hexnum = hex.hex_number
			var direction = Vector2()
			if hexnum % 2 == 0:
				direction = Vector2((10.5 - hexnum) * 3000, (10.5 - hexnum) * 3000)
			elif hexnum % 2 != 0:
				direction = Vector2((10.5 - hexnum) * 3000, (-10.5 + hexnum) * 3000)
			hex.position = hex.position.move_toward(direction, (550 - hexnum * 10) * delta)
			hex.rotation += hexnum * delta


	### when picked down and:
	elif (not is_picked_up and not is_inserted):
		### inserted into sockets
		if (is_insertable and inside_socket() and not inside_hex()):
			hexes.scale = hexes.scale.move_toward(Vector2(1, 1), 4 * delta)
			is_inserted = true
			insert_all(delta)
			HexfigureSingletone.emit_signal("time_to_check_winner")
		### not inserted and:
		else:
			hexes.scale = hexes.scale.move_toward(Vector2(idle_size_coeff, idle_size_coeff), 4 * delta)
			### already at the start position and idle
			if idle_state:
				hex_figure.position = hex_figure.position.move_toward(current_start_position, 2 * delta)
			### moving to the start position
			else:
				is_insertable = false # avoiding accidental insertions
				hex_figure.position = hex_figure.position.move_toward(start_position, 5000 * delta)
				# starting to be idle and floating
				if hex_figure.position == start_position:
					idle_state = true
					is_insertable = true
			# move every single hex
			for hex in hexes.get_children():
				hex.position = (hex.start_position + hex_figure.position)

#	print("total: ", inside_socket(), " picked_up: ", is_picked_up)

func _on_picked_up():
	is_picked_up = check_is_picked_up()
	if is_picked_up:
		is_inserted = false
		hexes.z_index = 1

func _on_picked_down():
	is_picked_up = false
	hexes.z_index = 0
		

# make figures floating when idle 
func _on_timer_timeout():
	current_start_position.x = start_position.x + rng.randi_range(-25, 25)
	current_start_position.y = start_position.y + rng.randi_range(-25, 25)



	
