extends Control


func _on_btn_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/main.tscn")


func _on_btn_quit_pressed() -> void:
	get_tree().quit()
