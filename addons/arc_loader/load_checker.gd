extends Node2D


signal scene_loaded


func _ready():
	emit_signal("scene_loaded")
