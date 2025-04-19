extends Control

@export var skins_scene : PackedScene

func _on_back_pressed() -> void:
	# Go back to the main menu scene
	get_tree().change_scene_to_file("res://scenes/main.tscn")
