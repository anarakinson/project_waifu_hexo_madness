extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	HexfigureSingletone.connect("on_picked_up", _on_picked_up)
	HexfigureSingletone.connect("on_picked_down", _on_picked_down)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_picked_up():
#	for hexfig in $Hexes.get_children():
#		if hexfig.is_picked_up():
#			$Hexes.remove_child(hexfig)
#			$ChosenLayer.add_child(hexfig)
	pass

func _on_picked_down():
#	for hexfig in $ChosenLayer.get_children():
#		$ChosenLayer.remove_child(hexfig)
#		$Hexes.add_child(hexfig)
	pass
