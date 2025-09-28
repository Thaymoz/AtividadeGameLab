extends CharacterBody2D
class_name Player

var move_speed := 300.0
var move_direction := Vector2.ZERO

func _physics_process(delta: float) -> void:
	move_direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = move_direction * move_speed
	
	move_and_slide()
