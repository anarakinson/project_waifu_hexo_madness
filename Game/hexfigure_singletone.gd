extends Node

signal on_picked_up 
signal on_picked_down 
signal time_to_check_winner
signal orientation_changed(orientation)

var current_location = ""
var current_level = 0
var level_settings_modifier = 0

#var current_OS = OS.get_name()
var current_OS = "Android"

var current_window_mode = 1
var current_resolution = 2

var current_orientation = 0 # 0 - landscape, 1 - portrait


var menu_scene = "res://UI/desktop/menu.tscn"
var main_scene = "res://Game/desktop/main.tscn"
var map_scene = "res://Game/desktop/map.tscn"
var quit_scene = "res://UI/desktop/quit_screen.tscn"
var test_config_scene = "res://UI/level_configuration.tscn"

var assets_path = "res://assets/desktop/"


var MAX_HEXFIGURE_NUMBERS = 11
var MAX_SINGLE_HEXES = 0
var MIN_FIGURE_SIZE = 2
var MAX_FIGURE_SIZE = 7



# Called when the node enters the scene tree for the first time.
func _ready():
	print(current_OS)
	match current_OS:
		"Windows", "macOS", "Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
			DisplayServer.window_set_size(Vector2(1280, 720))
			get_window().move_to_center()
		"Android", "iOS":
			menu_scene = "res://UI/mobile/menu.tscn"
			main_scene = "res://Game/mobile/main.tscn"
			map_scene = "res://Game/mobile/map.tscn"
			quit_scene = "res://UI/mobile/quit_screen.tscn"
			
			assets_path = "res://assets/mobile/"
			DisplayServer.window_set_size(Vector2i(480, 800))
			get_window().move_to_center()
			DisplayServer.screen_set_orientation(DisplayServer.SCREEN_PORTRAIT)
		"Web":
			print("Web")

	#match current_OS:
		#"Windows":
			#print("Windows")
			#DisplayServer.window_set_size(Vector2(1280, 720))
			##get_window().size = Vector2i(1152, 648)
			#get_window().move_to_center()
		#"macOS":
			#print("macOS")
		#"Linux":
			#print("Linux")
		#"FreeBSD", "NetBSD", "OpenBSD", "BSD":
			#print("BSD")
		#"Android":
			#print("Android")
			##get_window().size = Vector2i(500, 800)
			##get_viewport().set_size_override_stretch(true) # Enable stretch for custom size.
			##get_viewport().set_size_override(true, Vector2(720, 1280)) # Custom size for 2D.
			##DisplayServer.window_set_size(Vector2(720, 1280))
		#"iOS":
			#print("iOS")
		#"Web":
			#print("Web")





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if DisplayServer.screen_get_orientation() == 0:
		#print("landscape")
	#else:
		#print("portrait")
	

