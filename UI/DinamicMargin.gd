extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	handle_screen_resize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		handle_screen_resize()

func handle_screen_resize():
	var os_name = HexfigureSingletone.current_OS
	if os_name == "Android" or os_name == "iOS":
		var screen_size = get_viewport_rect().size
		var safe_area = DisplayServer.get_display_safe_area()
		var area_top = safe_area.position.y
		var area_side = safe_area.position.x 
		if os_name == "iOS":
			var screen_scale = DisplayServer.screen_get_scale()
			area_top = area_top / screen_scale 
			area_side = area_side / screen_scale
		if screen_size.x > screen_size.y:
			print("change to landscape")
			var margin = 60 
			add_theme_constant_override("margin_top", margin)
			add_theme_constant_override("margin_right", area_side + margin)
			add_theme_constant_override("margin_bottom", margin)
			add_theme_constant_override("margin_left", area_side + margin)
		else:
			print("change to portrait")
			var margin = 60 
			add_theme_constant_override("margin_top", margin + area_top)
			add_theme_constant_override("margin_right", margin)
			add_theme_constant_override("margin_bottom", margin + area_top)
			add_theme_constant_override("margin_left", margin)
		
