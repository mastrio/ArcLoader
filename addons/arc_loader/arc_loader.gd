extends Node


var can_load = true


func _switch_to_load_screen():
	get_tree().change_scene_to_file("res://addons/arc_loader/loading_screen.tscn")

func change_scene(current_scene: Node, new_scene: String):
	if not can_load:
		ArcLoader.log_msg("Couldn't load scene, busy finishing loading previous scene")
		return
	can_load = false
	
	if current_scene.scene_file_path == new_scene:
		ArcLoader.log_msg("Cannot load the currently active scene, use get_tree().reload_current_scene() instead")
		return
	
	LoadingScreen.new_scene = new_scene
	LoadingScreen.current_scene = current_scene
	LoadingScreen.get_node("AnimationPlayer").play_backwards("Fade")

func log_msg(message: String):
	print("[@|ArcLoader] " + message)

func log_err(message: String):
	print("[*|ArcLoader] " + message)
