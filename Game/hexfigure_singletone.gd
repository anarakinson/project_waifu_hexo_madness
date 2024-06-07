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


var ads_timeout = 3.0
var ads_timer = 0.



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
	
			DisplayServer.window_set_size(Vector2(648 / 4 * 3, 1152 / 4 * 3))
			get_window().move_to_center()
			
			MobileAds.initialize()
			#DisplayServer.screen_set_orientation(DisplayServer.SCREEN_PORTRAIT)
		"Web":
			print("Web")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#start ads timer
	ads_timer += delta


func save_game():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(location_map)
	file.store_var(available_pictures)
	file.store_var(players_money)
	file.store_var(player_name)
	file.close()


func load_game():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		location_map = file.get_var()
		available_pictures = file.get_var()
		players_money = file.get_var()
		player_name = file.get_var()
		file.close()
	else:
		pass



func check_ads_time(where):
	if rewarded_ad and ads_timer > (ads_timeout * 60):
		ads_timer = 0.
		SceneTransition.change_scene_to_file("res://UI/ads/ads_scene.tscn") 
	else:
		SceneTransition.change_scene_to_file(where) 







###############################################
#################  ADS  #######################
###############################################

var rewarded_ad : RewardedAd
var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()
var rewarded_ad_load_callback := RewardedAdLoadCallback.new()
var full_screen_content_callback := FullScreenContentCallback.new()


func _on_load_ads_pressed():
	rewarded_ad_load_callback.on_ad_failed_to_load = on_rewarded_ad_failed_to_load
	rewarded_ad_load_callback.on_ad_loaded = on_rewarded_ad_loaded

	full_screen_content_callback.on_ad_dismissed_full_screen_content = func() -> void:
		destroy()
	
	RewardedAdLoader.new().load("ca-app-pub-3940256099942544/1712485313", AdRequest.new(), rewarded_ad_load_callback)


func on_rewarded_ad_failed_to_load(adError : LoadAdError) -> void:
	print(adError.message)

func on_rewarded_ad_loaded(rewarded_ad : RewardedAd) -> void:
	print("rewarded ad loaded" + str(rewarded_ad._uid))
	rewarded_ad.full_screen_content_callback = full_screen_content_callback

	var server_side_verification_options := ServerSideVerificationOptions.new()
	server_side_verification_options.custom_data = "TEST PURPOSE"
	server_side_verification_options.user_id = "user_id_test"
	rewarded_ad.set_server_side_verification_options(server_side_verification_options)

	self.rewarded_ad = rewarded_ad

func _on_show_ads_pressed():
	if rewarded_ad:
		rewarded_ad.show(on_user_earned_reward_listener)

func destroy():
	if rewarded_ad:
		rewarded_ad.destroy()
		rewarded_ad = null #need to load again
		SceneTransition.change_scene_to_file(HexfigureSingletone.main_scene) 
