extends Control


@onready var blackout_rect = $ColorRect

var blackout_on_process = false
var blackout_off_process = false

# Called when the node enters the scene tree for the first time.
func _ready():
	blackout_rect.visible = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if blackout_on_process:
		if blackout_rect.color.a8 < 255:
			blackout_rect.color.a8 += 5
		else:
			blackout_on_process = false

	elif blackout_off_process:
		if blackout_rect.color.a8 > 0:
			blackout_rect.color.a8 -= 5
		else:
			blackout_rect.visible = false
			blackout_off_process = false
		


func off():
	blackout_off_process = true

func on():
	blackout_rect.visible = true
	blackout_on_process = true
	
