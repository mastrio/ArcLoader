@tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("ArcLoader", "res://addons/arc_loader/arc_loader.gd")
	add_autoload_singleton("LoadingScreen", "res://addons/arc_loader/loading_screen.tscn")


func _exit_tree():
	remove_autoload_singleton("ArcLoader")
	remove_autoload_singleton("LoadingScreen")
