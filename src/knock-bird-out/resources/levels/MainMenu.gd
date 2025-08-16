extends Node2D
class_name MainMenu


func OnStartButtonPressed() -> void:
	get_tree().change_scene_to_file("uid://b7dwtjwuhtfr3") # This goes to Main Game

func OnExitButtonPressed() -> void:
	get_tree().quit()
