@tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("ArcLoader", "res://addons/arc_loader/arc_loader.gd")


func _exit_tree():
	remove_autoload_singleton("ArcLoader")
