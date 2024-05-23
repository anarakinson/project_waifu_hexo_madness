extends Area2D

@onready var label = $Label

@export var point_name = "Level"

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = point_name
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	HexfigureSingletone.current_location = point_name
	SceneTransition.change_scene_to_file(HexfigureSingletone.main_scene) 
