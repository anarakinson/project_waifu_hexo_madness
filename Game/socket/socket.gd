extends Node2D

@onready var socket_area = $SocketArea

var is_occupied = false
var socket_number = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_center():
	pass

func _on_area_2d_area_entered(area):
#	if area.name == "HexArea":
#		is_occupied = true
	pass


func _on_socket_area_area_exited(area):
#	if area.name == "HexArea":
#		is_occupied = false
	pass


func set_text(text):
	$Label.text = str(text)
