extends Control

signal just_changed

@onready var option_button = $HBoxContainer/OptionButton as OptionButton
var current_mode = 1


const WINDOW_MODE_ARRAY : Array[String] = [
	"Fullscreen",
	"WindowMode",
	"Borderless",
	"BorderlessFullscreen",
]
# Called when the node enters the scene tree for the first time.
func _ready():
	add_window_mode_items()
	option_button.item_selected.connect(on_window_mode_selected)
	option_button.select(current_mode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func add_window_mode_items():
	for window_mode in WINDOW_MODE_ARRAY:
		option_button.add_item(window_mode)

func on_window_mode_selected(index):
	match index:
		0: #fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			#current_mode = "fullscreen" 
		1: #window mode
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			#current_mode = "window"
		2: #fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			#current_mode = "window"
		3: #window fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			#current_mode = "fullscreen"
	current_mode = index
	just_changed.emit()


