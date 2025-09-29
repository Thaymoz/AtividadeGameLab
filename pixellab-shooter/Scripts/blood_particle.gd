extends CPUParticles2D
var aleatority : float

func _ready() -> void:
	aleatority = randf_range(5, 12)

func _on_timer_timeout() -> void:
	set_physics_process(false)
	set_process(false)
	set_process_internal(false)
	set_process_input(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)
	await get_tree().create_timer(aleatority).timeout
	queue_free()
