extends Node2D

@onready var sprite = $Sprite2D
@export var default_texture = "res://assets/mobile/map.jpg"

var menu_image = "menuscreen.jpg"
var quitscreen_image = "quitscreen.jpg"
var image_list = [
	### blue
	#"Default_cyberpunk_white_blue_neon_full_size_lanscape_backgro_3.jpg",
	#"Default_cyberpunk_white_blue_neon_full_size_full_body_backgr_1.jpg",
	#"Default_cyberpunk_white_blue_neon_full_size_full_body_backgr_0.jpg",
	#"Default_cyberpunk_white_blue_neon_full_size_lanscape_backgro_1.jpg",
	#"Default_cyberpunk_white_blue_neon_full_size_lanscape_backgro_2.jpg",
	### green
	"Default_cyberpunk_green_0.jpg",
	"Default_cyberpunk_green_1.jpg",
	"Default_cyberpunk_green_2.jpg",
	"Default_cyberpunk_green_3.jpg",
	"Default_cyberpunk_green_4.jpg",
	"Default_cyberpunk_green_5.jpg",
	"Default_cyberpunk_green_6.jpg",
	"Default_cyberpunk_green_7.jpg",
]

var img_list_size = len(image_list)

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = load(default_texture)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func load_image(img_name):
#	var image = Image.load_from_file("assets/" + img_name)
##	image.resize(500, 600)
#	var texture = ImageTexture.create_from_image(image)
#	sprite.texture = texture
	sprite.texture = load(HexfigureSingletone.assets_path + img_name)
	sprite.scale = Vector2(1.2, 1.2)
	#sprite.position = Vector2(570, 300)
