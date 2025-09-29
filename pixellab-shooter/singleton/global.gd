extends Node

signal score_update

var player

#a gente começa zerado porem define sempre este valor como algo novo quando ele muda
var score := 0 :
	set(value):
		score = value
		score_update.emit(value)
