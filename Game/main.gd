extends Node2D

signal recreate
signal menu_call

var time_to_check = false
@onready var congrats = $Congrats
@onready var dancing_girl = $Congrats/DancingGirl 
@onready var current_location_label = $LabelCurrentLocation
@onready var current_level_label = $LabelCurrentLevel
@onready var start_point = $StartZone
@onready var hexes = $Hexes
@onready var sock_figure = $Sockets/SocketFigure
@onready var sockets_position = $Sockets/SocketsPosition
@onready var side_menu_panel = $SideMenuPanel
@onready var main_scene_camera = $MainSceneCamera
@onready var blocking_screen = $BlockingScreen
@onready var timer_label = $Label2

@onready var waifa_main = $Waifa
@onready var background = $Background

var time_to_show : float = 0
var best_time : String = ""
var numbers_showed = false
var first_loop = true
var hint_active = false

var figure = preload("res://Game/hex/hex_figure_4x4.tscn")
var rng = RandomNumberGenerator.new()

# game main difficult configurations
var MAX_HEXFIGURE_NUMBERS = HexfigureSingletone.MAX_HEXFIGURE_NUMBERS
var MAX_SINGLE_HEXES = HexfigureSingletone.MAX_SINGLE_HEXES
var MIN_FIGURE_SIZE = HexfigureSingletone.MIN_FIGURE_SIZE
var MAX_FIGURE_SIZE = HexfigureSingletone.MAX_FIGURE_SIZE

#var number_of_sockets
var yet_not_used
var hexes_numbers = []
var num_of_deleted_hexes = 0

#
#var ads_counter = 0;


var save_path = HexfigureSingletone.save_path

var current_location = HexfigureSingletone.current_location
var current_level = HexfigureSingletone.location_map[current_location]
var level_settings_modifier = HexfigureSingletone.level_settings_modifier


# Called when the node enters the scene tree for the first time.
func _ready():
	HexfigureSingletone.connect("on_picked_up", _on_picked_up)
	HexfigureSingletone.connect("on_picked_down", _on_picked_down)
	HexfigureSingletone.connect("time_to_check_winner", _time_to_check_winner)

	blocking_screen.visible = false
	congrats.visible = false
	var idx = (current_level + 
		level_settings_modifier) % background.img_list_size
	background.load_image(background.image_list[idx])
	
	current_location_label.text = current_location
	current_level_label.text = "Level: " + str(current_level)

	# setup before first loop
	first_loop = true
	# load ads
	HexfigureSingletone._on_load_ads_pressed()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# stuff for testing
	best_time = update_timer(delta)
	timer_label.text = best_time
	if HexfigureSingletone.ads_timer > (HexfigureSingletone.ads_timeout * 60):
		timer_label.text += "\nads ready\n" 
	
	# on very first loop - create tiles and field
	if Input.is_action_just_pressed("Menu"):
		menu_call.emit()
		
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
			$Congrats.text += "\n" + best_time
			victory_condition()


func victory_condition():
	# save level statistics to TXT
	save_statistics()
	# wait a little and make effects
	await get_tree().create_timer(0.1).timeout
	blocking_screen.visible = true
	congrats.visible = true
	dancing_girl.play("win")
	for hex in hexes.get_children():
		hex.is_explodes = true
		sock_figure.is_explodes = true
		sock_figure.visible = false
	waifa_main.reveales()
	# add random number to level picture number, when loaded
	if (current_level % 5 == 0):
		set_level_settings_modifier(rng.randi_range(0, 10))
	# change level
	HexfigureSingletone.current_level += 1
	HexfigureSingletone.location_map[current_location] += 1
	HexfigureSingletone.players_money += 100
	HexfigureSingletone.emit_signal("update_money_counter")

	# await before change level
	# rhytmic vibration
	rhytmic_vibration()
	await get_tree().create_timer(1.5).timeout
	_on_recreate()


#######################################################

func update_timer(delta):
	time_to_show += delta
	var msec = fmod(time_to_show, 1) * 100
	var seconds = fmod(time_to_show, 60)
	var minutes = fmod(time_to_show, 3600) / 60
	return ("%02d" % minutes) + (":%02d." % seconds) + ("%03d" % msec)

#######################################################

var delete_not_used_list = [
	#range(20, 38) + range(8, 13),
	range(20, 38) + range(10, 19),
	range(20, 38) + [10, 11, 12, 16, 17, 18],
	range(20, 38) + [
		1, 3, 5, 7 
	],
	range(20, 38) + [
		8, 10, 12, 14, 16, 18 
	],
	range(20, 38) + [
		9, 11, 13, 15, 17, 19 
	],
	range(20, 38),
	[
		1, 2, 3, 4, 5, 6, 7,
	],
	[
		22, 21, 
		25, 24, 
		28, 27, 
		31, 30, 
		34, 33, 
		37, 36, 
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


# variables for make figures
func get_numbers_graph_size():
	yet_not_used = numbers_graph.keys()


func clean_not_used():
	for num in delete_not_used:
		numbers_graph.erase(num)
		for i in numbers_graph.keys():
			#print(i)
			if num in numbers_graph[i]:
				#print(i, " - ", num, " - ", numbers_graph[i])
				numbers_graph[i].erase(num)





func generate_hex_numbers():
	# reset hexes_numbers
	hexes_numbers = []
	#yet_not_used = range(1, number_of_sockets + 1)
	yet_not_used = numbers_graph.keys()
	
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
			
		) or fail_counter > 100_000:
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
	if len(hexes.get_children()) < 4:
		start_point.position.x -= 70
	if len(hexes.get_children()) > 8:
		start_point.position.x -= 25
		x_step = 165
	if len(hexes.get_children()) > 3:
		start_point.position.y -= 90
	for hexfigure in hexes.get_children():
		# update start position for the next hex
		if (HexfigureSingletone.current_OS == "Android" or 
			HexfigureSingletone.current_OS == "iOS"):
			hexfigure.position = (start_point.position + 
									Vector2(y_step * y_shift, x_step * x_shift))
		else:
			hexfigure.position = (start_point.position + 
									Vector2(x_step * x_shift, y_step * y_shift))
		y_shift += 1
		if y_shift >= 4:
			x_shift += 1
			y_shift = 0
			
		#break


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
	#get_tree().reload_current_scene()
	HexfigureSingletone.save_game()
	HexfigureSingletone.check_ads_time(HexfigureSingletone.main_scene)
	#SceneTransition.change_scene_to_file(HexfigureSingletone.main_scene) 


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
	
	if current_level <= 5:
		MAX_FIGURE_SIZE = 4
	elif current_level <= 15:
		MAX_FIGURE_SIZE = 5
	
	#sock_figure.position = sockets_position.position
	delete_not_used = delete_not_used_list[current_level % len(delete_not_used_list)]
	clean_not_used()
	get_numbers_graph_size()
	update_socket_fig()
	generate_hexes()
	
	if current_level <= 5:
		num_of_deleted_hexes = len(hexes_numbers) / 2 - 1
		num_of_deleted_hexes = 2
	elif current_level <= 15:
		num_of_deleted_hexes = 1
	
	delete_some_hexes(num_of_deleted_hexes)
	set_hexes_on_start_position()
	
	if (HexfigureSingletone.current_OS == "Android" or HexfigureSingletone.current_OS == "iOS"):
		for hex in hexes.get_children():
			hex.scale *= 1.5
		#sock_figure.scale *= 1.5
	
	sock_figure.visible = true
	hexes.visible = true


func set_level_settings_modifier(number):
	HexfigureSingletone.level_settings_modifier = number


func _on_show_numbers_pressed():
	print(numbers_showed)
	numbers_showed = not numbers_showed
	for hexfig in hexes.get_children():
		for hex in hexfig.hexes.get_children():
			hex.hex_label.visible = numbers_showed



func _on_regenerate_pressed():
	if not player_money_check(100):
		return
	_on_recreate()



func _on_menu_call():
	$PauseMenu._paused()

func _on_menu_pressed():
	_on_menu_call()


func _on_skip_level_pressed():
	# change level
	HexfigureSingletone.current_level += 1
	HexfigureSingletone.location_map[current_location] += 1
	# await before change level
	#await get_tree().create_timer(0.5).timeout
	_on_recreate()



func _on_map_pressed():
	SceneTransition.change_scene_to_file(HexfigureSingletone.map_scene) 


func _on_test_with_configs_pressed():
	SceneTransition.change_scene_to_file(HexfigureSingletone.test_config_scene) 


func _on_gallery_pressed():
	SceneTransition.change_scene_to_file(HexfigureSingletone.gallery_scene) 


func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		SceneTransition.change_scene_to_file(HexfigureSingletone.map_scene) 


func _on_side_menu_pressed():
	side_menu_panel.is_opened = true



func _on_hint_pressed():
	if hint_active == false:
		if not player_money_check(50):
			return
		
		hint_active = true
		var hexes_children : Array
		for child in hexes.get_children():
			if not child.is_inserted:
				hexes_children.append(child)
		if len(hexes_children) <= 0:
			return
		# get random index
		var idx = rng.randi_range(0, len(hexes_children)-1)
		var default_color = hexes_children[idx].modulate
		hexes_children[idx].modulate = Color(255, 0, 0, 200)
		await get_tree().create_timer(0.3).timeout
		hexes_children[idx].modulate = default_color
		
		var numbers = []
		for hex in hexes_children[idx].hexes.get_children():
			numbers.append(hex.hex_number)
		for sock in sock_figure.sockets.get_children():
			if sock.socket_number in numbers:
				default_color = sock.modulate
				sock.modulate = Color(255, 0, 0, 200)
				sock.z_index = 2
		await get_tree().create_timer(0.2).timeout
		for sock in sock_figure.sockets.get_children():
			if sock.socket_number in numbers:
				sock.modulate = default_color
				sock.z_index = 0
		
		hint_active = false



func rhytmic_vibration():
	main_scene_camera.apply_shake(30)
	$Explosion.explode()
	$Explosion2.emitting(true)
	Input.vibrate_handheld(150)
	await get_tree().create_timer(0.3).timeout
	Input.vibrate_handheld(150)
	await get_tree().create_timer(0.3).timeout
	Input.vibrate_handheld(300)


func player_money_check(value : int):
	if HexfigureSingletone.players_money < value:
		$Money.bump()
		return false
	HexfigureSingletone.players_money -= value
	HexfigureSingletone.emit_signal("update_money_counter")
	HexfigureSingletone.save_game()
	return true




func save_statistics():
	
	var sys_path = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
	var filepath = sys_path + "/WaifuHexoMadness " + HexfigureSingletone.player_name + " - statistics.txt"
	var file
	if not FileAccess.file_exists(filepath):
		file = FileAccess.open(filepath, FileAccess.WRITE)
	else:
		file = FileAccess.open(filepath, FileAccess.READ_WRITE)
		file.seek_end()
	file.store_string("location: ")
	file.store_line(HexfigureSingletone.current_location)
	file.store_string("level: ")
	file.store_line(str(HexfigureSingletone.current_level))
	file.store_string("money: ")
	file.store_line(str(HexfigureSingletone.players_money))
	file.store_string("number of figures: ")
	file.store_line(str(len(hexes_numbers) - num_of_deleted_hexes))
	file.store_string("number of blocked on field figures: ")
	file.store_line(str(num_of_deleted_hexes))
	file.store_string("number of hexes in field: ")
	file.store_line(str(len(numbers_graph.keys())))
	file.store_string("max number of hexes in figure: ")
	file.store_line(str(MAX_FIGURE_SIZE))
	file.store_string("time: ")
	file.store_line(str(best_time))

	file.store_line("\n...\n")
	file.close()

