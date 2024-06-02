extends Node2D

@onready var waifa = $Waifa
@onready var back = $Back


var gallery_prefix = "res://assets/girls/"
var unavailable_picture = "back_of_a_card.jpg"
var waifa_pictures = [
	"cyberpunk_maiden_1",
	"cyberpunk_maiden_2",
	"cyberpunk_maiden_3",
	"cyberpunk_maiden_4",
	"cyberpunk_maiden_5",
	"cyberpunk_maiden_6",
	"cyberpunk_maiden_7",
	"cyberpunk_maiden_8",
	"cyberpunk_maiden_9",
	"cyberpunk_maiden_10",
]
var current_pic = 0

var available_pictures = HexfigureSingletone.available_pictures



# Called when the node enters the scene tree for the first time.
func _ready():
	back.texture = load(gallery_prefix + unavailable_picture)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func next():
	current_pic += 1
	if current_pic >= len(waifa_pictures):
		current_pic = 0
	waifa.texture = load(gallery_prefix + waifa_pictures[current_pic] + ".jpg")
	if current_pic in available_pictures:
		back.modulate.a8 = 0
	else:
		back.modulate.a8 = 255

func previous():
	current_pic -= 1
	if current_pic < 0:
		current_pic = len(waifa_pictures) - 1
	waifa.texture = load(gallery_prefix + waifa_pictures[current_pic] + ".jpg")
	if current_pic in available_pictures:
		back.modulate.a8 = 0
	else:
		back.modulate.a8 = 255


func unlock():
	var tween = get_tree().create_tween()
	tween.tween_property(back, "modulate:a", 0, 0.3)
	#back.modulate.a8 = 0


func save_image():
	var sys_path = OS.get_system_dir(OS.SYSTEM_DIR_PICTURES)
	var dir = DirAccess.open(sys_path)
	dir.make_dir("Waifu_Hexo_Madness")
	#DirAccess.make_dir_absolute("user://saves")

	var img = waifa.texture.get_image()
	#img.save_png(sys_path + "/Waifu_Hexo_Madness/" + waifa_pictures[current_pic] + ".png")
	img.save_png(sys_path + "/Waifu_Hexo_Madness/" + waifa_pictures[current_pic] + ".png")



