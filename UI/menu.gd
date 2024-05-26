extends Node2D


#@onready var background = $Background/Background
@onready var buttons = $Buttons
@onready var background = $Background/Background



# Called when the node enters the scene tree for the first time.
func _ready():
	background.load_image(background.menu_image)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_pressed():
	SceneTransition.change_scene_to_file(HexfigureSingletone.quit_scene)


func _on_start_pressed():
	SceneTransition.change_scene_to_file(HexfigureSingletone.map_scene) 


func _on_button_pressed():
	HexfigureSingletone.load_game()
	SceneTransition.change_scene_to_file(HexfigureSingletone.map_scene) 
	

func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		SceneTransition.change_scene_to_file(HexfigureSingletone.quit_scene) 
		
