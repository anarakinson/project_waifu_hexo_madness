extends Node2D

var time_to_check = false
@onready var congrats = $Label
@onready var current_level = $LabelCurrentLevel
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


#var yet_not_used = [
#	1, 2, 3, 4, 5, 6, 7, 8, 9,
#	10,11,12,13,14,15,16,17,18,19 
#]
var yet_not_used = range(1, 20)
const ALREADY_USED_MAX = 19


#var numbers_graph = [
#	[1], #0
#	[2, 3, 4, 5, 6, 7], #1
#	[9, 10, 11], #2
#	[11, 12, 13], #3
#	[13, 14, 15], #4
#	[15, 16, 17], #5
#	[17, 18, 19], #6
#	[19, 8, 9], #7
#
#	[7, 9, 19], #8
#
#	[], #9
#	[2], #10
#	[], #11
#	[3], #12
#	[], #13
#	[4], #14
#	[], #15
#	[5], #16
#	[], #17
#	[6], #18
#
#	[18, 6, 7, 8], #19
#]
var numbers_graph = {
	0 : [1], #0
	1 : [2, 3, 4, 5, 6, 7], #1
	2 : [9, 10, 11], #2
	3 : [11, 12, 13], #3
	4 : [13, 14, 15], #4
	5 : [15, 16, 17], #5
	6 : [17, 18, 19], #6
	7 : [19, 8, 9], #7
	
	8 : [7, 9, 19], #8
	
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
	elif number == 19 or number == 8:
		pass 
	
	return nearest


func generate_hexes():
	var rng = RandomNumberGenerator.new()

	var x_shift = 0
	var y_shift = 0
	var counter = 0
	# start generating hex figures
	while true:
		print("new hex figure")
		# if all parts of big hex are used
		if len(yet_not_used) <= 0:
			break
		
		# generate new figure template
		var new_figure = figure.instantiate() 
		hexes.add_child(new_figure)
		new_figure.enumerate_hexes()
		
		# create new lenght and start number
		var lenght = rng.randi_range(2, 5)
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
#			print("hexes numbers: ", start_number, " - ", numbers_array)
		
		hexes_numbers.append(numbers_array)
		
#	counter = 0
#	for hexfig in hexes.get_children():
#		print("hexes numbers: ", hexes_numbers[counter])
		new_figure.generate_figure(hexes_numbers[counter])
		new_figure.position = start_point.position + Vector2(200 * x_shift, 150 * y_shift)
		new_figure.centralize()

		counter += 1
		y_shift += 1
		if y_shift >= 4:
			x_shift += 1
			y_shift = 0
	if len(hexes_numbers) > 8:
		recreate()

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


#func get_hexes_numbers(start_number, length):
#	var out = []
#	var rng = RandomNumberGenerator.new()
##	var start_hex = load("res://Game/hex/hex.tscn").instantiate()
#
#	var new_figure = figure.instantiate() 
#	hexes.add_child(new_figure)
#	for hex in new_figure.hexes.get_children():
#		print(hex.name, " ", hex.hex_number, " - ")
#		if hex.hex_number == start_number:
#			var start_hex = hex
#			print(out)
#			return out
#
#

#			out.append(start_hex.hex_number)
#			var areas = start_hex.centre.get_overlapping_areas
#
#			print(out)
#			var counter = 0
#			while true:
#				if len(areas) == 0:
#					return out
#				counter += 1
#				if counter >= 20:
#					break
#				var rand_number = rng.randi_range(0, len(areas))
#				var hex_number = areas[rand_number].get_parent().hex_number
#				if hex_number not in already_used:
#					out.append(hex_number)
#					already_used.append(hex_number)
#				if len(already_used) >= already_used_max or len(out) >= length:
#					break
#			return out
