extends Node2D

signal not_enough_money
signal hide_button_pressed

@onready var gallery_waifa = $GalleryWaifa
@onready var unlock_button = $Buttons/Unlock
@onready var pic_number = $PicNumber
@onready var save_button = $Buttons/SaveImg


var current_waifa = "Waifa1"

# Called when the node enters the scene tree for the first time.
func _ready():
	update_waifu()
	pic_number.text = "Current pic: " + str(gallery_waifa.current_pic)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	swipe_detection()
	pass


func _on_next_pressed():
	gallery_waifa.next()
	update_waifu()
	pic_number.text = "Current pic: " + str(gallery_waifa.current_pic)
	$Buttons/Next.disabled = true
	await get_tree().create_timer(0.1).timeout
	$Buttons/Next.disabled = false


func _on_previous_pressed():
	gallery_waifa.previous()
	update_waifu()
	pic_number.text = "Current pic: " + str(gallery_waifa.current_pic)
	$Buttons/Previous.disabled = true
	await get_tree().create_timer(0.1).timeout
	$Buttons/Previous.disabled = false


func _on_unlock_pressed():
	if HexfigureSingletone.players_money >= 100:
		HexfigureSingletone.available_pictures[current_waifa].append(gallery_waifa.current_pic)
		update_waifu()
		HexfigureSingletone.players_money -= 100
		HexfigureSingletone.update_money_counter.emit()
		HexfigureSingletone.save_game()
	else:
		not_enough_money.emit()


func _on_save_img_pressed():
	gallery_waifa.save_image()


func update_waifu():
	if gallery_waifa.current_pic in HexfigureSingletone.available_pictures[current_waifa]:
		gallery_waifa.unlock()
		unlock_button.disabled = true
		save_button.disabled = false
	else:
		gallery_waifa.lock()
		unlock_button.disabled = false
		save_button.disabled = true



func update_available():
	gallery_waifa.current_pic = 0
	gallery_waifa.available_pictures = HexfigureSingletone.available_pictures[current_waifa]
	pic_number.text = "Current pic: " + str(gallery_waifa.current_pic)
	update_waifu()
	gallery_waifa.refresh()

func _on_hide_button_pressed():
	visible = false
	hide_button_pressed.emit()



signal swipe
var swipe_start = null
var minimum_drag = 100


func swipe_detection():
	if Input.is_action_just_pressed("m1"):
		swipe_start = get_global_mouse_position()
	if Input.is_action_just_released("m1"):
		_calculate_swipe(get_global_mouse_position())
		
func _calculate_swipe(swipe_end):
	if swipe_start == null: 
		return
	var swipe = swipe_end - swipe_start
	print(swipe)
	if abs(swipe.x) > minimum_drag:
		print(swipe)
		if swipe.x > 0:
			emit_signal("swipe", "right")
		else:
			emit_signal("swipe", "left")

func _on_swipe(dir):
	if dir == "right":
		_on_previous_pressed()
	elif dir == "left":
		_on_next_pressed()
