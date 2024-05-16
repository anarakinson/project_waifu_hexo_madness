extends Control

var is_paused = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.visible = true
	pass # Replace with function body.


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
	get_tree().change_scene_to_file("res://UI/menu.tscn")


func _on_resume_pressed():
	_paused()


func _on_quit_pressed():
	_paused()
	get_tree().change_scene_to_file("res://UI/quit_screen.tscn")
