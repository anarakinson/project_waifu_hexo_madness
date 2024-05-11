extends Node2D


@onready var hex_figure = $HexFigureArea
@onready var hexes = $Hexes

var start_position = Vector2()
var is_inserted = false


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
func is_picked_up():
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
	# save start position
	start_position = hex_figure.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (is_picked_up()):
		for hex in hexes.get_children():
			if hex.picked_up:
				hex_figure.position = hex.position - hex.start_position
				is_inserted = false
				HexfigureSingletone.emit_signal("on_picked_up")
			hex.position = (hex.start_position + hex_figure.position)

#	elif (not is_picked_up() and is_inserted):
#		insert_all(delta)

	elif (not is_picked_up() and not is_inserted):
		if (inside_socket() and not inside_hex()):
			is_inserted = true
			insert_all(delta)
		else:
			hex_figure.position = hex_figure.position.move_toward(start_position, 5000 * delta)
			for hex in hexes.get_children():
				hex.position = (hex.start_position + hex_figure.position)
	

#	print("hex1: ", hex1.inside_socket, " picked_up: ", hex1.picked_up)
#	print("hex2: ", hex2.inside_socket, " picked_up: ", hex2.picked_up)
#	print("hex3: ", hex3.inside_socket, " picked_up: ", hex3.picked_up)
#	print("total: ", inside_socket(), " picked_up: ", is_picked_up())

