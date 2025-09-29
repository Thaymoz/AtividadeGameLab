extends CharacterBody2D
class_name Player

@export var bullet_scene : PackedScene
var can_shoot : bool = true
var cd_shoot : float = 0.3

var move_speed := 300.0
var move_direction := Vector2.ZERO

var powerups = {
	"rapid_fire" : false,
	"mega_shoot" : false,
	"freze_enemies" : false,
}

func  _ready() -> void:
	Global.player = self

func _physics_process(_delta: float) -> void:
#movimentação do player para andar para os 4 lados
	move_direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = move_direction * move_speed

#Aqui verifica a possição de onde esta mirando + o click literal do tiro
	var mouse_dir = get_global_mouse_position() - global_position
	if Input.is_action_pressed("shoot") and can_shoot == true:
		_shoot(mouse_dir)
	
	
	move_and_slide()


func _shoot(direction):
#calculo para atirar
	can_shoot = false
	var bullet_instance = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet_instance)
	bullet_instance.global_position = global_position
	bullet_instance.set_direction(direction)
	
	if powerups["mega_shoot"]:
		bullet_instance.scale *= 2
	await get_tree().create_timer(cd_shoot).timeout
	can_shoot = true


func apply_powerup(type : String):
#combinar algo
	match  type:
		"rapid_fire":
			powerups["rapid_fire"] = true
			cd_shoot = 0.01
			await get_tree().create_timer(3).timeout
			powerups["rapid_fire"] = false
			cd_shoot = 0.3
		"mega_shoot":
			powerups["mega_shoot"] = true
			await get_tree().create_timer(3).timeout
			powerups["mega_shoot"] = false
		"freze_enemies":
			powerups["freze_enemies"] = true
			Global.freze_enemies.emit(5.0)
			await get_tree().create_timer(3).timeout
			powerups["freze_enemies"] = false
