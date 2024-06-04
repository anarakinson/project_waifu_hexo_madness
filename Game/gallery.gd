extends Node2D


@onready var side_menu_panel = $SideMenuPanel
@onready var waifa_choosing_node = $WaifaChoosing


var waifa_pictures = {
	"Waifa1" : [
		"cyberpunk_maiden_1",
		"cyberpunk_maiden_2",
		"cyberpunk_maiden_3",
		"cyberpunk_maiden_4",
	],
	"Waifa2" : [
		"cyberpunk_maiden_5",
		"cyberpunk_maiden_6",
		"cyberpunk_maiden_7",
	],
	"Waifa3" : [
		"cyberpunk_maiden_8",
		"cyberpunk_maiden_9",
		"cyberpunk_maiden_10",
	]
}

# Called when the node enters the scene tree for the first time.
func _ready():
	waifa_choosing_node.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		SceneTransition.change_scene_to_file(HexfigureSingletone.map_scene) 


func _on_side_menu_pressed():
	side_menu_panel.is_opened = true


func _on_button_waifa_1_pressed():
	$Buttons.visible = false
	waifa_choosing_node.gallery_waifa.waifa_pictures = waifa_pictures["Waifa1"]
	waifa_choosing_node.current_waifa = "Waifa1"
	waifa_choosing_node.update_available()
	waifa_choosing_node.visible = true
	
func _on_button_waifa_2_pressed():
	$Buttons.visible = false
	waifa_choosing_node.gallery_waifa.waifa_pictures = waifa_pictures["Waifa2"]
	waifa_choosing_node.current_waifa = "Waifa2"
	waifa_choosing_node.update_available()
	waifa_choosing_node.visible = true

func _on_button_waifa_3_pressed():
	$Buttons.visible = false
	waifa_choosing_node.gallery_waifa.waifa_pictures = waifa_pictures["Waifa3"]
	waifa_choosing_node.current_waifa = "Waifa3"
	waifa_choosing_node.update_available()
	waifa_choosing_node.visible = true



func _on_waifa_choosing_not_enough_money():
	$Money.bump()

func _on_waifa_choosing_hide_button_pressed():
	$Buttons.visible = true
