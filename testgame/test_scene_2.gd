extends Node2D


func _on_button_pressed():
	ArcLoader.change_scene(self, load("res://testgame/test_scene_1.tscn"))
