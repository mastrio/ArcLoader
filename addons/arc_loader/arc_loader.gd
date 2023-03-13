extends Node


var can_load = true


func _switch_to_load_screen():
	get_tree().change_scene_to_file("res://addons/arc_loader/loading_screen.tscn")

func change_scene(new_scene: String, transition_speed: int = 1, loading_icon: String = "res://addons/arc_loader/loading_icon.tscn"):
	var current_scene = get_tree().current_scene
	
	if not can_load:
		log_msg("Couldn't load scene, busy finishing loading previous scene")
		return
	can_load = false
	
	if not is_instance_valid(current_scene):
		log_err("The current scene is not set, please make sure that get_tree().current_scene is not null")
		return
	
	if current_scene.scene_file_path == new_scene:
		log_err("Cannot load the currently active scene, use ArcLoader.reload_current_scene() instead")
		return
	
	LoadingScreen.new_scene = new_scene
	LoadingScreen.load_icon = load(loading_icon)
	LoadingScreen.get_node("AnimationPlayer").speed_scale = transition_speed
	LoadingScreen.get_node("AnimationPlayer").play_backwards("Fade")

func reload_current_scene(transition_speed: int = 1, loading_icon: String = "res://addons/arc_loader/loading_icon.tscn"):
	if not can_load:
		log_msg("Couldn't load scene, busy finishing loading previous scene")
		return
	can_load = false
	
	LoadingScreen.reloading_scene = true
	LoadingScreen.load_icon = load(loading_icon)
	LoadingScreen.get_node("AnimationPlayer").speed_scale = transition_speed
	LoadingScreen.get_node("AnimationPlayer").play_backwards("Fade")

func log_msg(message: String):
	print("[@|ArcLoader] " + message)

func log_err(message: String):
	print("[*|ArcLoader] " + message)
