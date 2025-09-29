extends Area2D

@export var type : String = "rapid_fire"
@onready var sprite: Sprite2D = $Sprite


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.apply_powerup(type)
		queue_free()
