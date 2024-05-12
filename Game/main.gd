extends Node2D

var time_to_check = false
@onready var congrats = $Label
@onready var start_point = $StartZone
@onready var hexes = $Hexes

#var start_hex = preload("res://Game/hex/hex.tscn")
var figure = preload("res://Game/hex/hex_figure_3x3.tscn")


var hexes_numbers = [
#	[6, 9, 10, 11], 
#	[12, 13, 14], 
#	[5, 3, 2, 1],
#	[15, 16, 17, 18, 19],
#	[28, 29, 30, 31]
]

var already_used = []
var already_used_max = 19


func generate_hexes():
	var rng = RandomNumberGenerator.new()
	
	var counter = 0
	while true:
		counter += 1
		if counter > 5:
			break
		var lenght = rng.randi_range(1, 6)
		var start_number = rng.randi_range(0, 19)
		var new_figure = figure.instantiate() 
		hexes.add_child(new_figure)
		
	
		var numbers_array = []
		while true:
			var rand_number = rng.randi_range(1, 19)

			if rand_number not in already_used:
				already_used.append(rand_number)
				numbers_array.append(rand_number)
			if len(numbers_array) >= 4 or len(already_used) >= 19:
				break
		hexes_numbers.append(numbers_array)
		if len(already_used) >= 19:
				break


	counter = 0
	var x_shift = 0
	var y_shift = 0
	for hexfig in hexes.get_children():
		print(hexes_numbers[counter])
		hexfig.generate_figure(hexes_numbers[counter])
		hexfig.position = start_point.position + Vector2(200 * x_shift, 150 * y_shift)
		hexfig.centralize()
		counter += 1

		y_shift += 1
		if counter >= 4:
			x_shift += 1
			y_shift = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	congrats.visible = false
	HexfigureSingletone.connect("on_picked_up", _on_picked_up)
	HexfigureSingletone.connect("on_picked_down", _on_picked_down)
	HexfigureSingletone.connect("time_to_check_winner", _time_to_check_winner)
	generate_hexes()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if time_to_check:
		var not_inserted = 0
		for hexfig in hexes.get_children():
			if not hexfig.is_inserted:
				not_inserted += 1
		if (not_inserted == 0):
			congrats.visible = true
		time_to_check = false


func _on_picked_up():
#	for hexfig in hexes.get_children():
#		if hexfig.is_picked_up():
#			hexfig.z_index = 1
#			break
	pass

func _on_picked_down():
#	for hexfig in hexes.get_children():
	pass

func _time_to_check_winner():
	time_to_check = true
