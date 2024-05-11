extends Node2D

signal mouse_released
signal picked_up_changed(picked)

@onready var timer = $Timer 

var picked_up = false 
var current_position = Vector2()
var inside_socket = false
var inside_hex = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if picked_up:
		global_position = get_global_mouse_position()
	if Input.is_action_just_released("m1"):
		mouse_released.emit()


func insertion(delta):
	global_position = global_position.move_toward(current_position, 1000)


func _on_button_pressed():
	if not picked_up:
		timer.start(0.1)

func _on_timer_timeout():
	if not picked_up:
		picked_up = true 
		await mouse_released 
		picked_up = false 
		HexfigureSingletone.emit_signal("on_picked_down")
	

func _on_mouse_released():
	if not timer.is_stopped():
		timer.stop()
		picked_up = true 
		await mouse_released
		picked_up = false
		HexfigureSingletone.emit_signal("on_picked_down")
		

func _on_hex_area_area_entered(area):
	if area.name == "SocketArea":
		current_position = area.global_position
		inside_socket = true
	elif area.name == "HexArea":
		inside_hex = true
			


func _on_hex_area_area_exited(area):
	if area.name == "SocketArea":
		inside_socket = false
	elif area.name == "HexArea":
		inside_hex = false
