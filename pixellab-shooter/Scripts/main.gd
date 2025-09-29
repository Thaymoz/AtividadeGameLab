extends Node2D

@onready var player: Player = $Player
@onready var wave_txt: Label = %WaveTxt
@onready var score_txt: Label = %ScoreTxt
@onready var player_health: ProgressBar = %player_health


@export var enemy_scene : PackedScene
@export var spawn_margin := 200  


var active_enemies : Array =  []
var enemy_scenes : Dictionary = {
	"easy" : preload("res://Actors/enemy_c.tscn"),
	"medium" : preload("res://Actors/enemy_f.tscn"),
	"hard" : preload("res://Actors/enemy_hard.tscn"),
}

var power_ups_scenes : Dictionary = {
	"rapid_fire" : preload("res://Prefarbs/power_up_rapid_fire.tscn"),
	"mega_shoot" : preload("res://Prefarbs/power_up_mega_shoot.tscn"),
	"freze_enemies" : preload("res://Prefarbs/power_up_freze_enemies.tscn"),
}

var current_wave := 1
var enemies_per_wave := 3
var time_betwen_enemies := 0.3
var time_betwen_waves := 1.0
var is_spawning := false



func _ready() -> void:
	spawn_wave()
	wave_txt.text = "WAVES: %d" % current_wave
	score_txt.text = "SCORE:" + str("%02d" % Global.score)
	player_health.value = player.max_health
	player_health.max_value = player.max_health
	Global.score_update.connect(update_score_txt)


func spawn_enemy():
#ele verifica os tipos de inimigos que devem ser utilizados com base em cada wave
#ai assim ele pode spawanr literalmente os proximos inimigos
	var enemy_scene = get_enemy_scene_for_wave(current_wave)
#aqui literalemente spawna os inimigos
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.global_position = calculate_spawn_position()
#pega a variavel player do script que tem o node enemy e define como uma nova variavel
	enemy.player = player

#Ele adiciona os inimigos que spawnaram na lista de inimigos da wave 
#e depois verifica a função que retira os inimigos da lista 
	active_enemies.append(enemy)
	enemy.tree_exited.connect(on_enemy_exit.bind(enemy))


func get_enemy_scene_for_wave(wave : int) -> PackedScene:
	if wave < 3:
		return enemy_scenes["easy"]
	elif wave < 6:
		return enemy_scenes["medium"]
	else:
		return enemy_scenes["hard"]


func on_enemy_exit(enemy):
#esta função além de verificar a lista e remover o que esta escrito nela se o inimigo morrer
#ela controla as proximas waves ja que com ela ao ver que a lista ta vazia pode ir para a 
#proxima wave
	if enemy in active_enemies:
		active_enemies.erase(enemy)
	if active_enemies.is_empty():
		next_wave()


func spawn_wave():
	if is_spawning:
		return
	wave_txt.text = "WAVES: %d" % current_wave
	for i in enemies_per_wave:
		spawn_enemy()
		await get_tree().create_timer(time_betwen_enemies).timeout


func next_wave():
	await get_tree().create_timer(time_betwen_waves).timeout
	current_wave += 1
	enemies_per_wave += 1
	is_spawning = false
	spawn_wave()
	

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


func update_score_txt(score):
	score_txt.text = "SCORE:" + str("%02d" % Global.score)
	

func random_spawn_powerup():
	if randf() > 0.2:
		return
	var powerup_index = randi() % 3
	var powerup 
	
	if powerup_index == 0:
		powerup = power_ups_scenes["rapid_fire"].instantiate()
	elif powerup_index == 1:
		powerup = power_ups_scenes["mega_shoot"].instantiate()
	elif powerup_index == 2:
		powerup = power_ups_scenes["freze_enemies"].instantiate()
		
	if powerup:
		powerup.position = Vector2(randi_range(100,600),randi_range(100,400))
		add_child(powerup)


func _on_powerup_spawn_times_timeout() -> void:
	random_spawn_powerup()
