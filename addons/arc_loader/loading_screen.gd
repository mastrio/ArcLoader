extends Panel


var current_scene: Node = null
var new_scene: String = ""

var load_checker = preload("res://addons/arc_loader/load_checker.tscn")
var current_load_checker: Node2D

var can_load = true
var fade_in = false

var loading_thread: Thread
var loading_mutex: Mutex

var loaded_scene = null

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	loading_thread = Thread.new()
	loading_mutex = Mutex.new()

func _process(_delta):
	#global_position = get_viewport_rect().position
	if is_instance_valid(get_viewport().get_camera_2d()):
		global_position = get_viewport().get_camera_2d().global_position - (get_viewport_rect().size / 2)
	else:
		global_position = Vector2.ZERO

func _physics_process(_delta):
	get_tree().root.move_child(self, get_tree().root.get_node("/root").get_child_count())

func _exit_tree():
	loading_thread.wait_to_finish()

func start_loading():
	if not is_instance_valid(current_scene):
		ArcLoader.log_err("Error loading scene, current_scene is not a valid scene")
		return
	
	loading_thread.start(_thread_loading, Thread.PRIORITY_HIGH)
	var loaded_scene = loading_thread.wait_to_finish()
	
	if not is_instance_valid(loaded_scene):
		ArcLoader.log_err("Error loading scene, new_scene is not a valid scene or loading thread failed")
		return
	
	await get_tree().create_timer(1).timeout
	
	get_tree().root.add_child(loaded_scene)
	current_load_checker = load_checker.instantiate()
	current_load_checker.connect("scene_loaded", _scene_ready)
	loaded_scene.add_child(current_load_checker)

func _thread_loading():
	return load(new_scene).instantiate()

func _scene_ready():
	animation_player.stop(true)
	animation_player.play("Fade")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Fade":
		if fade_in:
			ArcLoader.can_load = true
		else:
			current_scene.queue_free()
			start_loading()
			animation_player.stop(true)
			animation_player.play("SPIN")
		
		fade_in = not fade_in
