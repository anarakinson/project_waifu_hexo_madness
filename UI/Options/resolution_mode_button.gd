extends Control


@onready var option_button = $HBoxContainer/OptionButton as OptionButton
var current_res = 2


const RESOLUTION_DICT : Dictionary = {
	"800×480" : Vector2(800, 480),
	"1152×648" : Vector2(1152, 648),
	"1280×720" : Vector2(1280, 720),
	"1920×1080" : Vector2(1920, 1080),
	#"480×800" : Vector2(480, 800),
	#"720×1280" : Vector2(720, 1280), # This is a common baseline resolution for mobile, 
	#"1080×1920" : Vector2(1080, 1920), # for crisper visuals at the cost of larger file sizes.
}

# Called when the node enters the scene tree for the first time.
func _ready():
	current_res = HexfigureSingletone.current_resolution
	add_resolution_size_items()
	option_button.item_selected.connect(on_resolution_selected)
	option_button.select(current_res)


func add_resolution_size_items():
	for resolution_size in RESOLUTION_DICT:
		option_button.add_item(resolution_size)

func on_resolution_selected(index):
	var resolution = RESOLUTION_DICT.values()[index]
	#get_viewport().set_size_override_stretch(true) # Enable stretch for custom size.
	#get_viewport().set_size_override(true, resolution) # Custom size for 2D.
	DisplayServer.window_set_size(resolution)
	HexfigureSingletone.current_resolution = index

