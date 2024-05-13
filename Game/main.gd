extends Node2D

var time_to_check = false
@onready var congrats = $Label
@onready var current_level = $LabelCurrentLevel
@onready var start_point = $StartZone
@onready var hexes = $Hexes

var figure = preload("res://Game/hex/hex_figure_3x3.tscn")

var MAX_HEXFIGURE_NUMBERS = 7
var MAX_SINGLE_HEXES = 0
var MIN_FIGURE_SIZE = 2
var MAX_FIGURE_SIZE = 6



var hexes_numbers = []
var yet_not_used = range(1, 20)
var ALREADY_USED_MAX = len(yet_not_used)


var numbers_graph = {
	0 : [1], #0
	1 : [2, 3, 4, 5, 6, 7], #1
	2 : [9, 10, 11], #2
	3 : [11, 12, 13], #3
	4 : [13, 14, 15], #4
	5 : [15, 16, 17], #5
	6 : [17, 18, 19], #6
	7 : [19, 8, 9], #7
	
	8 : [7], #8 !!! [7, 9, 19]
	9 : [], #9
	10 : [2], #10
	11 : [], #11
	12 : [3], #12
	13 : [], #13
	14 : [4], #14
	15 : [], #15
	16 : [5], #16
	17 : [], #17
	18 : [6], #18
	
	19 : [18, 6, 7, 8], #19
}


func get_near_n(number):
	var nearest = numbers_graph[number]
	if number == 1:
		pass
	elif number > 2 and number < 7:
		nearest += [1]
		nearest += [number - 1, number + 1]
	elif number == 2:
		nearest += [1, number + 1, 7]
	elif number == 7:
		nearest += [1, 2, number - 1]
	elif number > 8 and number < 19:
		nearest += [number - 1, number + 1]
		if number % 2 == 0:
			pass
		elif number % 2 != 0:
			nearest += numbers_graph[number + 1]
			nearest += numbers_graph[number - 1]
	elif number == 19:
		pass 
	elif number == 8:
		nearest += [9, 19]
	
	return nearest


func generate_hex_numbers():
	# reset hexes_numbers
	hexes_numbers = []
	yet_not_used = range(1, 20)
	
	var rng = RandomNumberGenerator.new()

	var counter = 0
	# start generating hex figures
	while true:
		print("new hex figure")
		# if all parts of big hex are used
		if len(yet_not_used) <= 0:
			break
		
		# create new lenght and start number
		var lenght = rng.randi_range(MIN_FIGURE_SIZE, MAX_FIGURE_SIZE)
		var start_id = rng.randi_range(0, len(yet_not_used)-1)
		var start_number = yet_not_used[start_id]
		yet_not_used.erase(start_number)
		
		# create sequence of hexes
		var numbers_array = []
		numbers_array.append(start_number)
		var stopper = 0
		while true:
			stopper += 1
			if stopper >= 10:
				break
			var nearest = get_near_n(start_number)
			for id in nearest:
				var next_id = rng.randi_range(0, len(nearest)-1)
				var next_hex_number = nearest[next_id]
				if next_hex_number in yet_not_used:
#					print(start_number, " - ", next_hex_number, " from ", nearest)
					numbers_array.append(next_hex_number)
					yet_not_used.erase(next_hex_number)
					start_number = next_hex_number
					if len(numbers_array) >= lenght or len(yet_not_used) <= 0:
						break
			if len(numbers_array) >= lenght or len(yet_not_used) <= 0:
				break
#			print("hexes numbers: ", start_number, " - ", numbers_array)
		
		hexes_numbers.append(numbers_array)
	

func generate_hexes():
	# generate numbers
	while true:
		generate_hex_numbers()
		print(hexes_numbers)
		# check if everything fine
		var have_single_hexes = 0
		for hex_number_arr in hexes_numbers:
			if len(hex_number_arr) == 1:
				have_single_hexes += 1
		# if something wrong - recreate scene
		if not (
			len(hexes_numbers) > MAX_HEXFIGURE_NUMBERS
			 or have_single_hexes > MAX_SINGLE_HEXES
		):
			break
	
	var counter = 0
	var x_shift = 0
	var y_shift = 0
	for i in range(len(hexes_numbers)):
#		print("hexes numbers: ", hexes_numbers[counter])
	
		# generate new figure template
		var new_figure = figure.instantiate() 
		hexes.add_child(new_figure)
		new_figure.enumerate_hexes()
		
		new_figure.generate_figure(hexes_numbers[i])
		new_figure.position = start_point.position + Vector2(200 * x_shift, 150 * y_shift)
		new_figure.centralize()

		y_shift += 1
		if y_shift >= 4:
			x_shift += 1
			y_shift = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	congrats.visible = false
	HexfigureSingletone.connect("on_picked_up", _on_picked_up)
	HexfigureSingletone.connect("on_picked_down", _on_picked_down)
	HexfigureSingletone.connect("time_to_check_winner", _time_to_check_winner)
	generate_hexes()
	current_level.text = "Level: " + str(HexfigureSingletone.current_level)
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
			recreate()
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



func recreate():
	HexfigureSingletone.current_level += 1
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()


