extends Node

signal on_picked_up 
signal on_picked_down 
signal time_to_check_winner

var current_level = 0
var level_settings_modifier = 0

var current_OS = OS.get_name()
#var current_OS = "Android"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
