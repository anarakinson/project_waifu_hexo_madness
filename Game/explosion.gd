extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():	
	$CPUParticles2D3.emitting = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if Input.is_action_just_pressed("m1"):
		#explode()
	pass

func emitting(val : bool):
	$CPUParticles2D3.emitting = val

func explode():
	$CPUParticles2D.emitting = true
	$CPUParticles2D2.emitting = true
	$CPUParticles2D3.emitting = true
