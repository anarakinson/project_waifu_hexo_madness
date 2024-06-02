extends Control


var player1_path = "user://saves/player1.save"
var player2_path = "user://saves/player2.save"
var player3_path = "user://saves/player3.save"

var which_slot_delete = 0

var players_money = 0
var player_name = "";
var location_map : Dictionary 
var available_pictures = [
]


# Called when the node enters the scene tree for the first time.
func _ready():
	$Confirm.visible = false
	
	$DeleteSlot1.visible = false
	$DeleteSlot2.visible = false
	$DeleteSlot3.visible = false

	if FileAccess.file_exists(player1_path):
		load_data(player1_path)
		$NewGameSlot1.text = player_name + "\nCoins: " + str(players_money)
		$DeleteSlot1.visible = true
	if FileAccess.file_exists(player2_path):
		load_data(player2_path)
		$NewGameSlot2.text = player_name + "\nCoins: " + str(players_money)
		$DeleteSlot2.visible = true
	if FileAccess.file_exists(player3_path):
		load_data(player3_path)
		$NewGameSlot3.text = player_name + "\nCoins: " + str(players_money)
		$DeleteSlot3.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_main_menu_pressed():
	SceneTransition.change_scene_to_file(HexfigureSingletone.menu_scene) 

func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		SceneTransition.change_scene_to_file(HexfigureSingletone.menu_scene) 
		



func _on_new_game_slot_1_pressed():
	HexfigureSingletone.save_path = player1_path
	HexfigureSingletone.player_name = "Game 1"
	if FileAccess.file_exists(HexfigureSingletone.save_path):
		HexfigureSingletone.load_game()
	else:
		HexfigureSingletone.save_game()
	SceneTransition.change_scene_to_file(HexfigureSingletone.map_scene)  


func _on_new_game_slot_2_pressed():
	HexfigureSingletone.save_path = player2_path
	HexfigureSingletone.player_name = "Game 2"
	if FileAccess.file_exists(HexfigureSingletone.save_path):
		HexfigureSingletone.load_game()
	else:
		HexfigureSingletone.save_game()
	SceneTransition.change_scene_to_file(HexfigureSingletone.map_scene)  


func _on_new_game_slot_3_pressed():
	HexfigureSingletone.save_path = player3_path
	HexfigureSingletone.player_name = "Game 3"
	if FileAccess.file_exists(HexfigureSingletone.save_path):
		HexfigureSingletone.load_game()
	else:
		HexfigureSingletone.save_game()
	SceneTransition.change_scene_to_file(HexfigureSingletone.map_scene)  


func load_data(save_path):
	var file = FileAccess.open(save_path, FileAccess.READ)
	location_map = file.get_var()
	available_pictures = file.get_var()
	players_money = file.get_var()
	player_name = file.get_var()
	file.close()


func _on_delete_slot_1_pressed():
	which_slot_delete = 1
	$Confirm.visible = true

func _on_delete_slot_2_pressed():
	which_slot_delete = 2
	$Confirm.visible = true
	
func _on_delete_slot_3_pressed():
	which_slot_delete = 3
	$Confirm.visible = true






func _on_confirm_yes_pressed():
	if which_slot_delete == 1:
		$NewGameSlot1.text = "New game"
		DirAccess.remove_absolute(player1_path)
		$DeleteSlot1.visible = false
	if which_slot_delete == 2:
		$NewGameSlot2.text = "New game"
		DirAccess.remove_absolute(player2_path)
		$DeleteSlot2.visible = false
	if which_slot_delete == 3:
		$NewGameSlot3.text = "New game"
		DirAccess.remove_absolute(player3_path)
		$DeleteSlot3.visible = false
	which_slot_delete = 0
	$Confirm.visible = false

func _on_confirm_no_pressed():
	$Confirm.visible = false
