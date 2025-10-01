extends Node

const CAMINHO_PARA_PONTUACAO_MAXIMA: String = "user://pontuacao-maxima.txt"

signal score_update
signal freze_enemies

var player
#a gente começa zerado porem define sempre este valor como algo novo quando ele muda
var score := 0 :
	set(value):
		score = value
		score_update.emit(value)
var high_score : int = 0

func _ready() -> void:
	ler_pontuacao()
	print(high_score)

func novo_highscore():
	if score >= high_score:
		high_score = score
		salvar_pontuacao()

func ler_pontuacao() -> void:
	var arquivo: FileAccess = FileAccess.open(CAMINHO_PARA_PONTUACAO_MAXIMA, FileAccess.READ)
	if arquivo:
		if arquivo.get_length() > 0:
			high_score = arquivo.get_as_text().to_int()
		else:
			print("arquivo vazio")
		arquivo.close()
	else:
		print("n foi possivel carregar o arquivo")

func salvar_pontuacao() -> void:
	var arquivo: FileAccess = FileAccess.open(CAMINHO_PARA_PONTUACAO_MAXIMA, FileAccess.WRITE)
	if arquivo:
		arquivo.store_string(str(high_score))
		arquivo.close()
	else:
		print("n carregou o arquivo")
