extends CanvasLayer


signal started_loading_scene
signal finished_loading_scene

var new_scene: String = ""

var load_checker = preload("res://addons/arc_loader/load_checker.tscn")
var current_load_checker: Node2D

var load_icon: PackedScene = preload("res://addons/arc_loader/loading_icon.tscn")
var icon_instance = null

var can_load = true
var fade_in = false

var reloading_scene = false

var loading_thread: Thread
var loading_mutex: Mutex

var loaded_scene = null

@onready var screen_panel = $ScreenPanel
@onready var animation_player: AnimationPlayer = $ScreenPanel/AnimationPlayer


func _ready():
	loading_thread = Thread.new()
	loading_mutex = Mutex.new()

func _process(_delta):
	pass
	if is_instance_valid(get_viewport().get_camera_2d()):
		screen_panel.global_position = get_viewport().get_camera_2d().global_position - (screen_panel.get_viewport_rect().size / 2)
	else:
		screen_panel.global_position = Vector2.ZERO

func _physics_process(_delta):
	get_tree().root.move_child(self, get_tree().root.get_node("/root").get_child_count())

func _exit_tree():
	loading_thread.wait_to_finish()

func start_loading():
	icon_instance = load_icon.instantiate()
	icon_instance.add_to_group("ArcLoader:LoadingIcon")
	add_child(icon_instance)
	
	loading_thread.start(_thread_loading, Thread.PRIORITY_HIGH)
	var loaded_scene = loading_thread.wait_to_finish()
	
	if not is_instance_valid(loaded_scene):
		ArcLoader.log_err("Error loading scene, new_scene is not a valid scene or loading thread failed")
		return
	
	await get_tree().create_timer(0.2).timeout
	
	get_tree().root.add_child(loaded_scene)
	current_load_checker = load_checker.instantiate()
	current_load_checker.connect("scene_loaded", _scene_ready)
	loaded_scene.add_child(current_load_checker)

func start_reloading():
	icon_instance = load_icon.instantiate()
	icon_instance.add_to_group("ArcLoader:LoadingIcon")
	add_child(icon_instance)
	
	emit_signal("started_loading_scene")
	
	get_tree().reload_current_scene()
	_scene_ready()

func _thread_loading():
	return load(new_scene).instantiate()

func _scene_ready():
	for child in get_children():
		if child.is_in_group("ArcLoader:LoadingIcon"):
			child.queue_free()
	
	animation_player.play("Fade")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Fade":
		if fade_in:
			emit_signal("finished_loading_scene")
			ArcLoader.can_load = true
		else:
			if reloading_scene:
				start_reloading()
				reloading_scene = false
			else:
				get_tree().unload_current_scene()
				start_loading()
		
		fade_in = not fade_in
