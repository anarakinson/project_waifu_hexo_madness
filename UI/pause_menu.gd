extends Control

var is_paused = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.visible = true
	#if (HexfigureSingletone.current_OS == "Android" or 
			#HexfigureSingletone.current_OS == "iOS"):
		#DisplayServer.window_set_size(Vector2i(480, 800))
		#DisplayServer.screen_set_orientation(DisplayServer.SCREEN_PORTRAIT)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _paused():
	if is_paused:
		hide()
		Engine.time_scale = 1
	elif not is_paused:
		show()
		Engine.time_scale = 0
	is_paused = !is_paused		
	pass


func _on_main_menu_pressed():
	_paused()
	SceneTransition.change_scene_to_file(HexfigureSingletone.menu_scene)


func _on_resume_pressed():
	_paused()


func _on_quit_pressed():
	_paused()
	SceneTransition.change_scene_to_file(HexfigureSingletone.quit_scene)
