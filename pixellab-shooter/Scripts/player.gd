extends CharacterBody2D
class_name Player

@export var bullet_scene : PackedScene
var can_shoot : bool = true
var cd_shoot : float = 0.1

var move_speed := 300.0
var move_direction := Vector2.ZERO

func  _ready() -> void:
	Global.player = self

func _physics_process(_delta: float) -> void:
#movimentação do player para andar para os 4 lados
	move_direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = move_direction * move_speed

#Aqui verifica a possição de onde esta mirando + o click literal do tiro
	var mouse_dir = get_global_mouse_position() - global_position
	if Input.is_action_just_pressed("shoot") and can_shoot == true:
		_shoot(mouse_dir)
	
	
	move_and_slide()


func _shoot(direction):
#calculo para atirar
	can_shoot = false
	var bullet_instance = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet_instance)
	bullet_instance.global_position = global_position
	bullet_instance.set_direction(direction)
	
	await get_tree().create_timer(cd_shoot).timeout
	can_shoot = true
