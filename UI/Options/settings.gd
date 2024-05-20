extends Control


@onready var window_mode_button = $WindowModeButton
@onready var resolution_mode_button = $ResolutionModeButton


func _on_window_mode_button_just_changed():
	if window_mode_button.current_mode == 0 or window_mode_button.current_mode == 3:
		resolution_mode_button.option_button.disabled = true
	if window_mode_button.current_mode == 1 or window_mode_button.current_mode == 2:
		resolution_mode_button.option_button.disabled = false
	else:
		pass

func _on_resolution_mode_button_just_changed():
	pass
