extends Panel


var current_scene: Node = null
var new_scene: String = ""

var load_checker = preload("res://addons/arc_loader/load_checker.tscn")
var current_load_checker: Node2D

var fade_in = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _physics_process(_delta):
	get_tree().root.move_child(self, get_tree().root.get_node("/root").get_child_count())

func start_loading():
	if not is_instance_valid(current_scene):
		ArcLoader.log_err("Error loading scene, current_scene is not a valid scene")
		return
	
	await get_tree().create_timer(1).timeout
	var loading_scene = load(new_scene).instantiate()
	
	if not is_instance_valid(loading_scene):
		ArcLoader.log_err("Error loading scene, new_scene is not a valid scene")
		return
	
	current_load_checker = load_checker.instantiate()
	
	loading_scene.add_child(current_load_checker)
	current_load_checker.connect("scene_loaded", _scene_ready)
	get_tree().root.add_child(loading_scene)
	
	new_scene = ""
	current_scene = null

func _scene_ready():
	animation_player.stop(true)
	animation_player.play("Fade")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Fade":
		if not fade_in:
			current_scene.queue_free()
			start_loading()
			animation_player.stop(true)
			animation_player.play("SPIN")
		
		fade_in = not fade_in
