extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Background.load_image($Background.image_list[1])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_pressed():
	get_tree().quit() # Replace with function body.


func _on_start_pressed():
	get_tree().change_scene_to_file("res://Game/main.tscn") # Replace with function body.
