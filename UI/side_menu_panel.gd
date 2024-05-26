extends Control

@onready var menu_panel = $MenuPanel
var start_position = Vector2()
var menu_width = 0
var is_opened = false


# Called when the node enters the scene tree for the first time.
func _ready():
	menu_width = menu_panel.texture.get_width() 
	start_position = menu_panel.position
	position.x = -menu_width * 2
	is_opened = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_menu(delta)
	pass


func _on_close_menu_pressed():
	is_opened = false


func move_menu(delta):
	if not is_opened:
		position = position.move_toward(
			Vector2(-menu_width * 2, 0), 
			1500 * delta
		)
	else:
		position = position.move_toward(
			Vector2(0, 0), 
			1500 * delta
		)


func _on_open_menu_pressed():
	is_opened = true
