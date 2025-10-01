extends "res://Scripts/enemy.gd"


signal health_changed(current: float, max: float)
signal died

@export var max_health :int = 20.0


func _ready() -> void:
	super()
	healt = max_health
	

func boss_damage(amount : int, source_position: Vector2 ):
	healt -= amount
	healt = clamp(healt, 0 , max_health)
	emit_signal("health_changed", healt , max_health)
	
	if healt <= 0: 
		emit_signal("died")
		queue_free()
	
	var knockback_dir = (position - source_position).normalized()
	apply_knockback(knockback_dir * knockback_force)
	hit_flash()
