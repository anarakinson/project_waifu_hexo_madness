extends Node2D


@onready var hex1 = $Hexes/Hex1
@onready var hex2 = $Hexes/Hex2
@onready var hex3 = $Hexes/Hex3
@onready var hex_figure = $HexFigureArea
@onready var hexes = $Hexes


var hex1_pos = Vector2()
var hex2_pos = Vector2()
var hex3_pos = Vector2()
var hexfig_pos = Vector2()
var start_position = Vector2()

var is_inserted = false


func inside_socket():
	var out = true
	for hex in hexes.get_children():
		out = (out and hex.inside_socket)
	return out
#	return (hex1.inside_socket and hex2.inside_socket and hex3.inside_socket)

func inside_hex():
	var out = false
	for hex in hexes.get_children():
		out = (out or hex.inside_hex)
	return out
#	return (hex1.inside_hex or hex2.inside_hex or hex3.inside_hex)

func is_picked_up():
	var out = false
	for hex in hexes.get_children():
		out = (out or hex.picked_up)
	return out
#	return (hex1.picked_up or hex2.picked_up or hex3.picked_up)


func insert_all(delta):
	for hex in hexes.get_children():
		hex.insertion(delta)
#	hex1.insertion(delta)
#	hex2.insertion(delta)
#	hex3.insertion(delta)


# Called when the node enters the scene tree for the first time.
func _ready():
	hex1_pos = hex_figure.position + hex1.position
	hex2_pos = hex_figure.position + hex2.position
	hex3_pos = hex_figure.position + hex3.position
	hexfig_pos = hex_figure.position
	start_position = hex_figure.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hex1.picked_up:
		hexfig_pos = hex1.position - hex1_pos
		is_inserted = false
		HexfigureSingletone.emit_signal("on_picked_up")

	elif hex2.picked_up:
		hexfig_pos = hex2.position - hex2_pos
		is_inserted = false
		HexfigureSingletone.emit_signal("on_picked_up")

	elif hex3.picked_up:
		hexfig_pos = hex3.position - hex3_pos
		is_inserted = false
		HexfigureSingletone.emit_signal("on_picked_up")
	
	hex1.position = hex1_pos + hexfig_pos
	hex2.position = hex2_pos + hexfig_pos
	hex3.position = hex3_pos + hexfig_pos
#	hex_figure.position = hexfig_pos

#	print("hex1: ", hex1.inside_socket, " picked_up: ", hex1.picked_up)
#	print("hex2: ", hex2.inside_socket, " picked_up: ", hex2.picked_up)
#	print("hex3: ", hex3.inside_socket, " picked_up: ", hex3.picked_up)
#	print("total: ", inside_socket(), " picked_up: ", is_picked_up())


	if (not is_picked_up() and is_inserted):
		insert_all(delta)
	elif (not is_picked_up() and not is_inserted):
		if (inside_socket() and not inside_hex()):
			is_inserted = true
			insert_all(delta)
		else:
			hexfig_pos = hexfig_pos.move_toward(start_position, 5000 * delta)

