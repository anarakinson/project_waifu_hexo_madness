extends Node2D

@onready var sprite = $Sprite
@onready var shade = $Shade


# Called when the node enters the scene tree for the first time.
func _ready():
	load_image("assets/pngwing.com.png", sprite)
	load_image("assets/pngwing.com.png", shade)
	#sprite.flip_h = true 
	#shade.flip_h = true 
	shade.modulate = Color(0,0,0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func reveales():
	var tween = get_tree().create_tween()
	tween.tween_property(shade, "modulate:a", 0, 0.5)
	tween.tween_callback(shade.queue_free)
	pass

func load_image(path, spr):
#	var image = Image.load_from_file(path)
#	var texture = ImageTexture.create_from_image(image)
#	spr.texture = texture
	spr.texture = load(path)
	spr.scale = Vector2(0.5, 0.5)
