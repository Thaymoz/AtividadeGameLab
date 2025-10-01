extends Control

@onready var highscore_txt: Label = %Highscore_txt

func _ready() -> void:
	highscore_txt.text = "HIGHSCORE:" + str("%02d" % Global.high_score)

func _on_btn_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/main.tscn")


func _on_btn_quit_pressed() -> void:
	get_tree().quit()
