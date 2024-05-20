extends Node2D


#@onready var background = $CanvasLayer/Control/Menu/Background
@onready var background = $Background/Background

# Called when the node enters the scene tree for the first time.
func _ready():
	background.load_image(background.menu_image)

	print(HexfigureSingletone.current_OS)
	match HexfigureSingletone.current_OS:
		"Windows":
			print("Windows")
			#DisplayServer.window_set_size(Vector2(800, 480))
			DisplayServer.window_set_size(Vector2(1280, 720))
			#get_window().size = Vector2i(1152, 648)
			#get_window().size = Vector2i(1280, 720)
			get_window().move_to_center()
		"macOS":
			print("macOS")
		"Linux":
			print("Linux")
		"FreeBSD", "NetBSD", "OpenBSD", "BSD":
			print("BSD")
		"Android":
			print("Android")
			DisplayServer.window_set_size(Vector2(720, 1280))			
		"iOS":
			print("iOS")
		"Web":
			print("Web")


	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_pressed():
	SceneTransition.change_scene_to_file("res://UI/quit_screen.tscn")


func _on_start_pressed():
	SceneTransition.change_scene_to_file("res://Game/main.tscn") # Replace with function body.



