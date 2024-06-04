extends Node

signal on_picked_up 
signal on_picked_down 
signal time_to_check_winner
signal orientation_changed(orientation)
signal update_money_counter

var current_location : String = "Junkyard"
var current_level : int = 0
var level_settings_modifier : int = 0

var location_map : Dictionary = {
	"City mall" : 0,
	"Junkyard" : 0,
	"School" : 0,
}

var available_pictures = {
	"Waifa1" : [],
	"Waifa2" : [],
	"Waifa3" : [],
	"Waifa4" : [],
	"Waifa5" : [],
	"Waifa6" : [],
	"Waifa7" : [],
	"Waifa8" : [],
}

var players_money = 500 #_000_000
var player_name = "Nonename"


#var current_OS = OS.get_name()
var current_OS : String = "Android"

var current_window_mode : int = 1
var current_resolution : int = 2

var current_orientation = 0 # 0 - landscape, 1 - portrait

var save_path = "user://saves/variable.save"

var menu_scene = "res://UI/desktop/menu.tscn"
var main_scene = "res://Game/desktop/main.tscn"
var choose_player_scene = "res://UI/desctop/choosing_player.tscn"
var map_scene = "res://Game/desktop/map.tscn"
var gallery_scene = "res://Game/desktop/gallery.tscn"
var quit_scene = "res://UI/desktop/quit_screen.tscn"
var test_config_scene = "res://UI/level_configuration.tscn"

var ads_scene = "res://addons/admob/sample/Main.tscn"
#var ads_scene = "res://addons/admob/test/Example.tscn"

var assets_path = "res://assets/desktop/"


var MAX_HEXFIGURE_NUMBERS = 11
var MAX_SINGLE_HEXES = 0
var MIN_FIGURE_SIZE = 2
var MAX_FIGURE_SIZE = 7




# Called when the node enters the scene tree for the first time.
func _ready():
	#ask permissions for mobile
	OS.request_permissions()
	# make save directorie
	var dir = DirAccess.open("user://")
	dir.make_dir("saves")
	DirAccess.make_dir_absolute("user://saves")
	
	
	print(current_OS)
	match current_OS:
		"Windows", "macOS", "Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
			DisplayServer.window_set_size(Vector2(1280, 720))
			get_window().move_to_center()
		"Android", "iOS":
			menu_scene = "res://UI/mobile/menu.tscn"
			main_scene = "res://Game/mobile/main.tscn"
			choose_player_scene = "res://UI/mobile/choosing_player.tscn"
			map_scene = "res://Game/mobile/map.tscn"
			gallery_scene = "res://Game/mobile/gallery.tscn"
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
	


func save_game():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	#file.store_var(current_level)
	#file.store_var(current_location)
	#file.store_var(level_settings_modifier)
	file.store_var(location_map)
	file.store_var(available_pictures)
	file.store_var(players_money)
	file.store_var(player_name)
	file.close()


func load_game():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		#current_level = file.get_var()
		#current_location = file.get_var()
		#level_settings_modifier = file.get_var()
		location_map = file.get_var()
		available_pictures = file.get_var()
		players_money = file.get_var()
		player_name = file.get_var()
		file.close()
	else:
		pass
		#current_level = 0
		#current_location = ""
		#level_settings_modifier = 0

