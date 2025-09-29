extends Node2D

var shake_strenght : float = 0.0
var shake_decay : float = 5.0

@onready var camera: Camera2D = $Camera

func _process(delta: float) -> void:
	if shake_strenght > 0:
		camera.offset = Vector2(randf_range(-1,1), randf_range(-1,1)) * shake_strenght
		shake_strenght = max(shake_strenght - shake_decay * delta, 0)
	else:
		camera.offset = Vector2.ZERO
		

func start_shake(strenght: float = 3.0, decay: float = 5.0):
	shake_strenght = strenght
	shake_decay = decay
