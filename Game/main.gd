extends Node2D

signal recreate

var time_to_check = false
@onready var congrats = $Label
@onready var current_level = $LabelCurrentLevel
@onready var start_point = $StartZone
@onready var hexes = $Hexes
@onready var sock_figure = $Sockets/SocketFigure

@onready var waifa_main = $Waifa
@onready var background = $Background

var numbers_showed = false
var first_loop = true

var figure = preload("res://Game/hex/hex_figure_4x4.tscn")
var rng = RandomNumberGenerator.new()

# game main difficult configurations
var MAX_HEXFIGURE_NUMBERS = 11
var MAX_SINGLE_HEXES = 0
var MIN_FIGURE_SIZE = 2
var MAX_FIGURE_SIZE = 7

var number_of_sockets
var yet_not_used
var hexes_numbers = []
	
var delete_not_used_list = [
	range(20, 38),
	[
		22, 21, #19,
		25, 24, #17,
		28, 27, #15,
		31, 30, #12,
		34, 33, #11,
		37, 36, #9, 
	],
	[
		1, 2, 3, 4, 5, 6, 7,
	],
	[
		20, 21,
		23, 24,
		26, 27,
		29, 30,
		33, 32,
		36, 35,
	],
	[
		1, 3, 5, 7, 13, 17, 9
	],
	[],
]

var delete_not_used = delete_not_used_list[0]
#var delete_not_used = range(20, 38)
#var delete_not_used = []

## required for finding nearby hexes. idk how to do that smarter way
#var numbers_graph = {
	##0 : [1], #0
	#1 : [2, 3, 4, 5, 6, 7], #1
	#2 : [9, 10, 11], #2
	#3 : [11, 12, 13], #3
	#4 : [13, 14, 15], #4
	#5 : [15, 16, 17], #5
	#6 : [17, 18, 19], #6
	#7 : [19, 8, 9], #7
	#
	#8 : [7], #8 !!! [7, 9, 19]
	#9 : [], #9
	#10 : [2], #10
	#11 : [], #11
	#12 : [3], #12
	#13 : [], #13
	#14 : [4], #14
	#15 : [], #15
	#16 : [5], #16
	#17 : [], #17
	#18 : [6], #18
	#
	#19 : [18, 6, 7, 8], #19
#
	##############
	##### 4x4 ####
	##############
	#
	#20 : [8, 19, 21], #20
	#21 : [18, 19], #21
	#22 : [18, 31], #22
	#23 : [17, 18, 31, 32], #23
	#24 : [16, 17, 32, 33], #24
	#25 : [16, 33, 34, 35], #25
	#26 : [15, 16, 35, 36], #26
	#27 : [14, 15, 36, 37], #27
	#28 : [14, 37], #28
	#29 : [13, 14], #29
	#30 : [12, 13, 29], #30
	#
	#31 : [22, 23, 32], #31
	#32 : [23, 24], #32
	#33 : [24, 25], #33
	#34 : [25], #34
	#35 : [25, 26], #35
	#36 : [26, 27], #36
	#37 : [36, 27, 28], #37
	#
#}

var numbers_graph = {
	1 : [2, 3, 4, 5, 6, 7], #1
	2 : [1, 3, 7, 19, 8, 9], #2
	3 : [1, 2, 4, 9, 10, 11], #3
	4 : [1, 3, 5, 11, 12, 13], #4
	5 : [1, 4, 6, 13, 14, 15], #5
	6 : [1, 5, 7, 15, 16, 17], #6
	7 : [1, 2, 6, 17, 18, 19], #7
	
	8 : [2, 9, 19, 37, 20, 21], #8
	9 : [2, 3, 8, 10, 21, 22], #9
	10 : [3, 9, 11, 22, 23, 24], #10
	11 : [3, 4, 10, 12, 24, 25], #11
	12 : [4, 11, 13, 25, 26, 27], #12
	13 : [4, 5, 12, 14, 27, 28], #13
	14 : [5, 13, 15, 28, 29, 30], #14
	15 : [5, 6, 14, 16, 30, 31], #15
	16 : [6, 15, 17, 31, 32, 33], #16
	17 : [6, 7, 16, 18, 33, 34], #17
	18 : [7, 17, 19, 34, 35, 36], #18
	19 : [7, 2, 18, 8, 36, 37], #19
	
	20 : [8, 37, 21], #20
	21 : [8, 9, 20, 22], #21
	22 : [9, 10, 21, 23], #22

	23 : [10, 22, 24], #23
	24 : [10, 11, 23, 25], #24
	25 : [11, 12, 24, 26], #25

	26 : [12, 25, 27], #26
	27 : [12, 13, 26, 28], #27
	28 : [13, 14, 27, 29], #28

	29 : [14, 28, 30], #29
	30 : [14, 15, 29, 31], #30
	31 : [15, 16, 30, 32], #31

	32 : [16, 31, 33], #32
	33 : [16, 17, 32, 34], #33
	34 : [17, 18, 33, 35], #34

	35 : [18, 34, 36], #35
	36 : [18, 19, 35, 37], #36
	37 : [19, 8, 36, 20], #37
}


# calculate nearby hexes
func get_near_n(number):
	return numbers_graph[number]


## calculate nearby hexes
#func get_near_n(number):
	#var nearest = numbers_graph[number]
	#if number == 1:
		#pass
	#elif number > 2 and number < 7:
		#nearest += [1]
		#nearest += [number - 1, number + 1]
	#elif number == 2:
		#nearest += [1, number + 1, 7]
	#elif number == 7:
		#nearest += [1, 2, number - 1]
	#elif number > 8 and number < 19:
		#nearest += [number - 1, number + 1]
		#if number % 2 == 0:
			#pass
		#elif number % 2 != 0:
			#nearest += numbers_graph[number + 1]
			#nearest += numbers_graph[number - 1]
	#elif number == 19:
		#pass 
	#elif number == 8:
		#nearest += [9, 19]
#
	##############
	##### 4x4 ####
	##############
	#elif number > 20 and number < 30:
		#nearest += [number + 1, number - 1]
	#elif number > 31 and number < 37:
		#nearest += [number + 1, number - 1]
	#
	#elif number == 20:
		#pass
	#elif number == 30:
		#pass
	#elif number == 31:
		#pass
	#elif number == 37:
		#pass
	#
	#return nearest


# variables for make figures
func get_numbers_graph_size():
	number_of_sockets = len(numbers_graph)
	#var number_of_sockets = 37 # 4x4
	#var number_of_sockets = len(sock_figure.sockets.get_children())
	yet_not_used = numbers_graph.keys()


func clean_not_used():
	for num in delete_not_used:
		numbers_graph.erase(num)
		for i in numbers_graph.keys():
			#print(i)
			if num in numbers_graph[i]:
				#print(i, " - ", num, " - ", numbers_graph[i])
				numbers_graph[i].erase(num)
	#for i in numbers_graph:
		#print(i, " - ", numbers_graph[i])

	pass





func generate_hex_numbers():
	# reset hexes_numbers
	hexes_numbers = []
	#yet_not_used = range(1, number_of_sockets + 1)
	yet_not_used = numbers_graph.keys()
	
	var counter = 0
	# start generating hex figures
	while true:
		# if all parts of big hex are used
		if len(yet_not_used) <= 0:
			break
		
		# create new lenght and start number
		var lenght = rng.randi_range(MIN_FIGURE_SIZE, MAX_FIGURE_SIZE)
		var start_id = rng.randi_range(0, len(yet_not_used)-1)
		var start_number = yet_not_used[start_id]
		yet_not_used.erase(start_number)
		
		# create sequence of hexes (fabulous govnocode)
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
			#print("hexes numbers: ", start_number, " - ", numbers_array)
		
		hexes_numbers.append(numbers_array)
		#break

# delete additional hexes from socket figure
func update_socket_fig():
	for sock in sock_figure.sockets.get_children():
		if sock.socket_number not in yet_not_used:
			sock.free()


func generate_hexes():
	# generate numbers until get the correct combination
	var fail_counter = 0
	while true:
		fail_counter += 1
		generate_hex_numbers()
#		print(hexes_numbers)
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
			print("SUCCESS after: ", fail_counter, " attempts")
			#print(hexes_numbers)
			break

	# creating figures and add into Hexes
	var counter = 0
	for i in range(len(hexes_numbers)):
#		print("hexes numbers: ", hexes_numbers[counter])
	
		# generate new figure template
		var new_figure = figure.instantiate() 
		hexes.add_child(new_figure)
		new_figure.enumerate_hexes()
		
		# set start positions
		new_figure.generate_figure(hexes_numbers[i])
		new_figure.centralize()
		new_figure.modulate.a8 = 220

func set_hexes_on_start_position():
	var x_shift = 0
	var y_shift = 0
	var x_step = 200
	var y_step = 150
	if len(hexes.get_children()) > 4:
		start_point.position.x -= 70
	if len(hexes.get_children()) > 8:
		start_point.position.x -= 25
		x_step = 165
	if len(hexes.get_children()) > 3:
		start_point.position.y -= 70
	for hexfigure in hexes.get_children():
		# update start position for the next hex
		hexfigure.position = start_point.position + Vector2(x_step * x_shift, y_step * y_shift)
		y_shift += 1
		if y_shift >= 4:
			x_shift += 1
			y_shift = 0
			
		#break


# Called when the node enters the scene tree for the first time.
func _ready():
	HexfigureSingletone.connect("on_picked_up", _on_picked_up)
	HexfigureSingletone.connect("on_picked_down", _on_picked_down)
	HexfigureSingletone.connect("time_to_check_winner", _time_to_check_winner)

	congrats.visible = false
	var idx = (HexfigureSingletone.current_level + 
		HexfigureSingletone.level_settings_modifier) % background.img_list_size
	background.load_image(background.image_list[idx])
	current_level.text = "Level: " + str(HexfigureSingletone.current_level)
	
	# setup before first loop
	first_loop = true
	sock_figure.visible = false
	hexes.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# on very first loop - create tiles and field
	if first_loop:
		first_loop = false
		generate_everything()
	
	# every time when figure inserted check win conditions
	if time_to_check:
		time_to_check = false
		var not_inserted = 0
		for hexfig in hexes.get_children():
			if not hexfig.is_inserted:
				not_inserted += 1
		
		# Player win!
		if (not_inserted <= 0):
			# wait a little and make effects
			await get_tree().create_timer(0.1).timeout
			congrats.visible = true
			for hex in hexes.get_children():
				hex.is_explodes = true
				sock_figure.is_explodes = true
			waifa_main.reveales()
			# add random number to level picture number, when loaded
			if (HexfigureSingletone.current_level % 5 == 0):
				HexfigureSingletone.level_settings_modifier = rng.randi_range(0, 10)
			# change level
			HexfigureSingletone.current_level += 1
			# await before change level
			await get_tree().create_timer(2.0).timeout
			_on_recreate()


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


func _on_recreate():
	get_tree().reload_current_scene()


func delete_some_hexes(number):
	var target_sockets = []
	var counter = 0
	for hex in hexes.get_children():
		counter += 1
		if counter > number: break
		for h in hex.hexes.get_children():
			var idx = h.hex_number
			target_sockets.append(idx)
		hex.free()
	#print(target_sockets)
	for sock in sock_figure.sockets.get_children():
		#print(sock)
		if sock.socket_number in target_sockets:
			sock.socket_area.free()
			sock.modulate.a8 = 100


func generate_everything():
	### SET SOCKET FIGURE
	
	if HexfigureSingletone.current_level <= 5:
		MAX_FIGURE_SIZE = 4
	elif HexfigureSingletone.current_level <= 15:
		MAX_FIGURE_SIZE = 5
	
	delete_not_used = delete_not_used_list[HexfigureSingletone.current_level % len(delete_not_used_list)]
	clean_not_used()
	get_numbers_graph_size()
	update_socket_fig()
	generate_hexes()
	
	var num_of_deleted_hexes = 0
	if HexfigureSingletone.current_level <= 5:
		num_of_deleted_hexes = len(hexes_numbers) / 2
	elif HexfigureSingletone.current_level <= 15:
		num_of_deleted_hexes = 1
	
	delete_some_hexes(num_of_deleted_hexes)
	set_hexes_on_start_position()
	#for hex in hexes.get_children():
		#hex.rotation = 33
		#hex.modulate = Color(0, 200, 0)
	#sock_figure.rotation = 33
	#sock_figure.modulate = Color(0, 100, 200)
	
	sock_figure.visible = true
	hexes.visible = true


func _on_show_numbers_pressed():
	print(numbers_showed)
	numbers_showed = not numbers_showed
	for hexfig in hexes.get_children():
		for hex in hexfig.hexes.get_children():
			hex.hex_label.visible = numbers_showed



func _on_regenerate_pressed():
	await get_tree().create_timer(0.5).timeout
	_on_recreate()
