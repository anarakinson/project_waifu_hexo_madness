extends Node2D

signal mouse_released
signal picked_up_changed(picked)

@onready var timer = $Timer 
@onready var hex_label = $Label
@onready var collision = $HexArea/CollisionShape2D

var start_position = Vector2()
var current_position = Vector2()
var picked_up = false 
var inside_socket = false
var inside_hex = false
var hex_number = 0
var picked_up_timeout = 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	start_position = position
	if (HexfigureSingletone.current_OS == "Android" or HexfigureSingletone.current_OS == "iOS"):
		picked_up_timeout = 0.0001

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if picked_up:
		pass
#		global_position = get_global_mouse_position()
#		global_position = global_position.move_toward(get_global_mouse_position(), 10_000 * delta)
	if Input.is_action_just_released("m1"):
		mouse_released.emit()


func set_text(text):
	hex_label.text = str(text)


func insertion(delta):
	global_position = global_position.move_toward(current_position, 10_000*delta)
#	global_position = current_position


func _on_button_pressed():
	if not picked_up:
		timer.start(picked_up_timeout)
		HexfigureSingletone.emit_signal("on_picked_up") 


func _on_timer_timeout():
	if not picked_up:
		picked_up = true
		HexfigureSingletone.emit_signal("on_picked_up") 
		await mouse_released 
		picked_up = false 
		HexfigureSingletone.emit_signal("on_picked_down")
	

func _on_mouse_released():
	if not timer.is_stopped():
		timer.stop()
		picked_up = true 
		HexfigureSingletone.emit_signal("on_picked_up")
		await mouse_released
		picked_up = false
		HexfigureSingletone.emit_signal("on_picked_down")
	

func _on_hex_area_area_entered(area):
	if area.name == "SocketArea":
		inside_socket = true
		current_position = area.get_parent().global_position
	elif area.name == "HexArea":
		inside_hex = true



func _on_hex_area_area_exited(area):
	if area.name == "SocketArea":
		inside_socket = false
	elif area.name == "HexArea":
		inside_hex = false

