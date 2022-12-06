extends Node


var _scene_to_load: PackedScene


func _switch_to_load_screen():
	get_tree().change_scene_to_file("res://addons/arc_loader/loading_screen.tscn")

func change_scene(current_scene: Node, new_scene: PackedScene):
	#print(current_scene.scene_file_path + " | " + new_scene.instantiate().scene_file_path)
	if current_scene.scene_file_path == new_scene.resource_path:
		print("[ArcLoader] Cannot load the currently active scene, use get_tree().reload_current_scene() instead")
		return
	
	_scene_to_load = new_scene
	#current_scene.queue_free()
	current_scene.add_child(preload("res://addons/arc_loader/fade_out.tscn").instantiate())
