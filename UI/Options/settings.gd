extends Control


@onready var window_mode_button = $WindowModeButton
@onready var resolution_mode_button = $ResolutionModeButton


func _ready():
	window_mode_button.on_window_mode_selected(HexfigureSingletone.current_window_mode)
	resolution_mode_button.on_resolution_selected(HexfigureSingletone.current_resolution)


func _on_window_mode_button_just_changed():
	var current_mode = HexfigureSingletone.current_window_mode
	if current_mode == 0 or current_mode == 3:
		resolution_mode_button.option_button.disabled = true
	if current_mode == 1 or current_mode == 2:
		resolution_mode_button.option_button.disabled = false
	else:
		pass
