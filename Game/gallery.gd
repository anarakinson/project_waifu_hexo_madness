extends Node2D

@onready var gallery_waifa = $GalleryWaifa
@onready var unlock_button = $Buttons/Unlock
@onready var pic_number = $PicNumber
@onready var save_button = $Buttons/SaveImg


# Called when the node enters the scene tree for the first time.
func _ready():
	update_waifu()
	pic_number.text = "Current pic: " + str(gallery_waifa.current_pic)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		SceneTransition.change_scene_to_file(HexfigureSingletone.map_scene) 
		


func _on_map_pressed():
	SceneTransition.change_scene_to_file(HexfigureSingletone.map_scene) 


func _on_next_pressed():
	gallery_waifa.next()
	update_waifu()
	pic_number.text = "Current pic: " + str(gallery_waifa.current_pic)
	


func _on_previous_pressed():
	gallery_waifa.previous()
	update_waifu()
	pic_number.text = "Current pic: " + str(gallery_waifa.current_pic)
	

func _on_unlock_pressed():
	HexfigureSingletone.available_pictures.append(gallery_waifa.current_pic)
	update_waifu()
	HexfigureSingletone.save_game()


func _on_save_img_pressed():
	gallery_waifa.save_image()


func update_waifu():
	if gallery_waifa.current_pic in HexfigureSingletone.available_pictures:
		gallery_waifa.unlock()
		unlock_button.disabled = true
		save_button.disabled = false
	else:
		unlock_button.disabled = false
		save_button.disabled = true

