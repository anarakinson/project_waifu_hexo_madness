extends Node2D

@onready var sockets = $Sockets

var is_explodes = false
var explode_counter = -0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	enumerate_hexes()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_explodes:
		explode_counter += 1 * delta
		if explode_counter < 0 :
			sockets.scale = sockets.scale.move_toward(Vector2(1.1, 1.1), 4 * delta)
		if explode_counter > 0 :
			sockets.scale = sockets.scale.move_toward(Vector2(1, 1), 0.3 * delta)
		
	pass



# just enumerate hexes
func enumerate_hexes():
	var counter = 0
	for socket in sockets.get_children():
		counter += 1
		socket.socket_number = counter
		socket.set_text(counter)
