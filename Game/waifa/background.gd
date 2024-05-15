extends Node2D

@onready var sprite = $Sprite2D

var menu_image = "Default_cyberpunk_green_blue_neon_full_size_lanscape_backgro_0.jpg"
var image_list = [
	### blue
	#"Default_cyberpunk_white_blue_neon_full_size_lanscape_backgro_3.jpg",
	#"Default_cyberpunk_white_blue_neon_full_size_full_body_backgr_1.jpg",
	#"Default_cyberpunk_white_blue_neon_full_size_full_body_backgr_0.jpg",
	#"Default_cyberpunk_white_blue_neon_full_size_lanscape_backgro_1.jpg",
	#"Default_cyberpunk_white_blue_neon_full_size_lanscape_backgro_2.jpg",
	### green
	"Default_cyberpunk_green_blue_neon_full_size_lanscape_backgro_3 (2).jpg",
	"Default_cyberpunk_green_blue_neon_full_size_lanscape_backgro_2 (1).jpg",
	"Default_cyberpunk_green_blue_neon_full_size_lanscape_backgro_1.jpg",
	"Default_cyberpunk_green_blue_neon_full_size_lanscape_backgro_3.jpg",
	"Default_cyberpunk_green_blue_neon_full_size_lanscape_backgro_2 (2).jpg",
	"Default_cyberpunk_green_blue_neon_full_size_lanscape_backgro_3 (1).jpg",
	"Default_cyberpunk_green_blue_neon_full_size_lanscape_backgro_2.jpg",
]

var img_list_size = len(image_list)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func load_image(img_name):
#	var image = Image.load_from_file("assets/" + img_name)
##	image.resize(500, 600)
#	var texture = ImageTexture.create_from_image(image)
#	sprite.texture = texture
	sprite.texture = load("assets/" + img_name)
	sprite.scale = Vector2(1.2, 1.2)
	sprite.position = Vector2(570, 300)
