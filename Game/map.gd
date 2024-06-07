extends Node2D


func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		SceneTransition.change_scene_to_file(HexfigureSingletone.quit_scene) 
		


func _on_gallery_pressed():
	SceneTransition.change_scene_to_file(HexfigureSingletone.gallery_scene) 


func _on_side_menu_pressed():
	$SideMenuPanel.is_opened = true



