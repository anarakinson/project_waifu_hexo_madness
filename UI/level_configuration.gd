extends Control

@onready var max_hexes_button = $MaxHexes/OptionButton
@onready var min_hexes_button = $MinHexes/OptionButton
@onready var max_figures_button = $MaxFigures/OptionButton
@onready var single_hexes_button = $SingleHexes/OptionButton

var gold_amount_value = HexfigureSingletone.players_money
var ads_timeout = HexfigureSingletone.ads_timeout

const VALUES_ARRAY : Array[String] = [
	"0", "1", "2", "3", "4", "5", 
	"6", "7", "8", "9", "10",
	"11", "12", "13", "14", "15",
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Gold/LineEdit.placeholder_text = str(gold_amount_value)
	$Gold/AcceptButton.disabled = true
	
	$AdsTimer/AdsTimerLineEdit.placeholder_text = str(ads_timeout)
	$AdsTimer/AdsAcceptButton.disabled = true
		
	$MaxHexes/Label.text += str(HexfigureSingletone.MAX_FIGURE_SIZE)
	$MinHexes/Label.text += str(HexfigureSingletone.MIN_FIGURE_SIZE)
	$MaxFigures/Label.text += str(HexfigureSingletone.MAX_HEXFIGURE_NUMBERS)
	$SingleHexes/Label.text += str(HexfigureSingletone.MAX_SINGLE_HEXES)
	
	add_window_mode_items(max_hexes_button, VALUES_ARRAY)
	add_window_mode_items(min_hexes_button, VALUES_ARRAY)
	add_window_mode_items(max_figures_button, VALUES_ARRAY)
	add_window_mode_items(single_hexes_button, VALUES_ARRAY)
	
	max_hexes_button.item_selected.connect(on_max_hexes_selected)
	min_hexes_button.item_selected.connect(on_min_hexes_selected)
	max_figures_button.item_selected.connect(on_max_figures_selected)
	single_hexes_button.item_selected.connect(on_single_hexes_selected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func add_window_mode_items(option_button, values_array):
	for value in values_array:
		option_button.add_item(value)


func on_max_hexes_selected(index):
	HexfigureSingletone.MAX_FIGURE_SIZE = int (VALUES_ARRAY[index])
	
func on_min_hexes_selected(index):
	HexfigureSingletone.MIN_FIGURE_SIZE = int (VALUES_ARRAY[index])

func on_max_figures_selected(index):
	HexfigureSingletone.MAX_HEXFIGURE_NUMBERS = int (VALUES_ARRAY[index])

func on_single_hexes_selected(index):
	HexfigureSingletone.MAX_SINGLE_HEXES = int (VALUES_ARRAY[index])


func _on_button_pressed():
	SceneTransition.change_scene_to_file(HexfigureSingletone.map_scene) 



func show_picture_tree():
	var path = OS.get_system_dir(OS.SYSTEM_DIR_PICTURES)
	print(path)
	$PicturePathLabel.text = "Pictures path: " + path
	
	$SysInfo.text = "SystemInfo: "
	$SysInfo.text += "\n  Model: " + OS.get_model_name() + \
		"\n  Processor: " + OS.get_processor_name() + \
		"\n  proc count: " + str(OS.get_processor_count())
	$SysInfo.text += "\n  Memory: "
	var meminfo = OS.get_memory_info()
	for x in meminfo:
		$SysInfo.text += "\n    " + str(x) + " : " + str(meminfo[x])
	#$PicturePathLabel.text += "\n" + OS.get_user_data_dir()

func _on_picture_path_pressed():
	show_picture_tree()
	$Permissions.text = "Permissions: "
	for p in OS.get_granted_permissions():
		$Permissions.text += "\n  " + p


func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		SceneTransition.change_scene_to_file(HexfigureSingletone.quit_scene) 
		


func _on_accept_button_pressed():
	$Gold/LineEdit.placeholder_text = str(gold_amount_value)
	HexfigureSingletone.players_money = gold_amount_value


func _on_line_edit_text_changed(new_text):
	if new_text.is_valid_float():
		gold_amount_value = int(new_text)
		$Gold/AcceptButton.disabled = false
	else: 
		$Gold/AcceptButton.disabled = true


func _on_ads_timer_line_edit_text_changed(new_text):
	if new_text.is_valid_float():
		ads_timeout = float(new_text)
		$AdsTimer/AdsAcceptButton.disabled = false
	else: 
		$AdsTimer/AdsAcceptButton.disabled = true


func _on_ads_accept_button_pressed():
	$AdsTimer/AdsTimerLineEdit.placeholder_text = str(ads_timeout)
	HexfigureSingletone.ads_timeout = ads_timeout
	HexfigureSingletone.ads_timer = 0
	
