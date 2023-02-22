extends Node2D


signal scene_loaded


func _ready():
	get_tree().current_scene = get_parent()
	emit_signal("scene_loaded")
