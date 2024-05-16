extends Node2D

var time_to_quit = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$Background.load_image($Background.quitscreen_image)
	$DancingGirl.play("default")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	await get_tree().create_timer(5.).timeout
	print("QUIT")
	time_to_quit = true
	get_tree().quit() # Replace with function body.


