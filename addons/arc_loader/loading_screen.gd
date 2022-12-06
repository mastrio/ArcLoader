extends Panel


var load_checker = preload("res://addons/arc_loader/load_checker.tscn")
var current_load_checker: Node2D


func _ready():
	await get_tree().create_timer(1).timeout
	
	var new_scene = ArcLoader._scene_to_load.instantiate()
	while not is_instance_valid(new_scene):
		new_scene = ArcLoader._scene_to_load.instantiate()
	
	current_load_checker = load_checker.instantiate()
	
	new_scene.add_child(current_load_checker)
	current_load_checker.connect("scene_loaded", scene_ready)
	get_tree().root.add_child(new_scene)

func scene_ready():
	$AnimationPlayer.stop(true)
	$AnimationPlayer.play("FadeIn")

func _on_animation_player_animation_finished(anim_name):
	print("AH")
	if anim_name == "FadeIn":
		queue_free()
