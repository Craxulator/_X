extends Control

func _on_start_pressed() -> void:
	# Change to whatever scene is first
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings_menu.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
