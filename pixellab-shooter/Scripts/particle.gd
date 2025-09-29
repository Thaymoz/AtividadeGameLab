extends Node2D

var aleatority : float
var can_fade : bool  = false
var alpha : float = 1.0

func _ready() -> void:
	aleatority = randf_range(1, 5)
	await get_tree().create_timer(aleatority).timeout
	can_fade = true


func _process(delta: float) -> void:
	if can_fade:
#"caminhe" até lá
		alpha = lerp(alpha, 0.0 , 0.1)
		modulate.a = alpha
	if alpha < 0.005:
		queue_free()
