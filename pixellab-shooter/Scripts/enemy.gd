extends CharacterBody2D

const BLOOD_PARTICLE = preload("res://Prefarbs/blood_particle.tscn")
@onready var Sprite: Sprite2D = $Sprite

@export var move_speed : float = 100
@export var healt : int = 3
@export var score : int = 10

var original_color := Color.WHITE
var direction : Vector2 = Vector2.ZERO
var player = null
var knowback_velocity : Vector2 = Vector2.ZERO
var knowcback_decay : float = 800
var knockback_force : float = 400

var is_frozen : bool = false

func  _ready() -> void:
	player = Global.player 
	original_color = Sprite.modulate
	Global.freze_enemies.connect(_on_freze_enemies)


func _physics_process(delta: float) -> void:
	if is_frozen:
		velocity = Vector2.ZERO
		move_and_slide()
		return
#É o seguinte este if anterior ele calcula para ver se ele tomou algum knowback
#caso ele ja tenha tomado ele vai configurar a velocidade dele para ser o knowckback
#então vai andar. Depois disso ele calucla a direção a qual isto vai acontecer e com que força
	if knowback_velocity.length() > 1:
		velocity = knowback_velocity
		move_and_slide()
		knowback_velocity = knowback_velocity.move_toward(Vector2.ZERO, knowcback_decay *delta)
#Ai caso não tenha ocorrido nem um impulso ele vai executar essa função de andar
#que até então é sempre executada na direção do player
	else:
		if player:
			direction = global_position.direction_to(player.global_position)
			velocity = direction * move_speed
		
		move_and_slide()

#faz com que aconteça o knowback
func apply_knockback(force: Vector2):
	knowback_velocity = force

func hit_flash():
	Sprite.modulate = Color.WHITE
	await  get_tree().create_timer(0.1).timeout
	Sprite.modulate = original_color

func take_damage(amount: int, source_position: Vector2):
	healt -= amount
# Ele define a direção do knowckback que é a posição dele menos o source(Q n sei exatamente o que é)
# e usa o normalized para n ter erro na diagonal.Então ele aplica na função do knowback a direção
	var knockback_dir = (position - source_position).normalized()
	apply_knockback(knockback_dir * knockback_force)
	hit_flash()
	if healt <= 0:
		var blood_instance = BLOOD_PARTICLE.instantiate()
		add_sibling(blood_instance)
		blood_instance.global_position = global_position
		blood_instance.rotation = direction.angle() + PI
		queue_free()
		Global.score += score
	print("Enemy Health is:" + str(healt))
	
func _on_freze_enemies(duration : float):
	is_frozen = true
	await  get_tree().create_timer(duration).timeout
	is_frozen = false
	
