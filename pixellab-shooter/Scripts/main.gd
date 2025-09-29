extends Node2D

@onready var player: Player = $Player

@export var enemy_scene : PackedScene
@export var spawn_margin := 200  

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.global_position = calculate_spawn_position()
#pega a variavel player do script que tem o node enemy e define como uma nova variavel
	enemy.player = player
	
# -> == return
func calculate_spawn_position() -> Vector2:
	var screen_size = get_viewport().get_visible_rect().size
	var player_pos = player.global_position
#aqui ele diz que o lugar onde eles vão nascer é a margin da tela mais a distancia q definimos
	var spawn_distance := screen_size.length() / 2 + spawn_margin
#aqui ele faz com que os inimigos eles nasçam em formato de relogio então por exemplo 
# se o inimigo nasceu em linha reta em direção ao player o proximo vai nascer em um angulo
#de 15 graus a mais do que o anterior (isto é um exemplo)
	var angle := randf_range(0, TAU)
	var spawn_pos = player_pos + Vector2.RIGHT.rotated(angle) * spawn_distance
	
	return spawn_pos


func _on_spawn_timer_timeout() -> void:
	spawn_enemy()
