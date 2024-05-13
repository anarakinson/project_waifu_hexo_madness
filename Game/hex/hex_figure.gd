extends Node2D


@onready var hex_figure = $HexFigureArea
@onready var hexes = $Hexes
@export var figure_number = 0


var start_position = Vector2()
var is_inserted = false
var is_picked_up = false


var figure_centre = Vector2()


func generate_figure(hexes_numbers):
	for hex in hexes.get_children():
		if (hex.hex_number not in hexes_numbers):
			hex.free()

func enumerate_hexes():
	var counter = 0
	for hex in hexes.get_children():
		counter += 1
		hex.hex_number = counter
		hex.set_text(counter)


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


func insert_all(delta):
	for hex in hexes.get_children():
		hex.insertion(delta)


# Called when the node enters the scene tree for the first time.
func _ready():
	HexfigureSingletone.connect("on_picked_up", _on_picked_up)
	HexfigureSingletone.connect("on_picked_down", _on_picked_down)
	# save start position
	start_position = hex_figure.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_picked_up:
		hexes.scale = hexes.scale.move_toward(Vector2(1, 1), 4 * delta)
		for hex in hexes.get_children():
			if hex.picked_up:
				hex_figure.position = (hex.position - hex.start_position)
				HexfigureSingletone.emit_signal("on_picked_up")
			hex.position = (hex.start_position + hex_figure.position)
#			hex.position = hex.position.move_toward(hex.start_position + hex_figure.position, 1_000_000)

	elif (not is_picked_up and not is_inserted):
		if (inside_socket() and not inside_hex()):
			hexes.scale = hexes.scale.move_toward(Vector2(1, 1), 4 * delta)
			is_inserted = true
			insert_all(delta)
			HexfigureSingletone.emit_signal("time_to_check_winner")
		else:
			hexes.scale = hexes.scale.move_toward(Vector2(0.8, 0.8), 4 * delta)
			hex_figure.position = hex_figure.position.move_toward(start_position, 5000 * delta)
			for hex in hexes.get_children():
				hex.position = (hex.start_position + hex_figure.position)
	

#	print("hex1: ", hex1.inside_socket, " picked_up: ", hex1.picked_up)
#	print("hex2: ", hex2.inside_socket, " picked_up: ", hex2.picked_up)
#	print("hex3: ", hex3.inside_socket, " picked_up: ", hex3.picked_up)
#	print("total: ", inside_socket(), " picked_up: ", is_picked_up)

func _on_picked_up():
	is_picked_up = check_is_picked_up()
	if is_picked_up:
		is_inserted = false
		hexes.z_index = 1

func _on_picked_down():
	is_picked_up = false
	hexes.z_index = 0
		
