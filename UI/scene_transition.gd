extends CanvasLayer





func change_scene_to_file(target : String, type : String = "dissolve"):
	if type == "dissolve":
		transition_dissolve(target)

func transition_dissolve(target):
	$AnimationPlayer.play("dissolve")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("dissolve")
