class_name LevelManager extends Control

@onready var skybox_camera_3d: Camera3D = $SkyboxViewport/SkyboxCamera3D
@onready var game_viewport: SubViewport = $GameViewport
@onready var stage_timer: Timer = $"Stage Timer"

var current_level_index : int = 0
var catto : CattoBall 
var catto_spawner : Marker3D

const ready_buffer_screen : PackedScene = preload("res://menus/level_ready_screen/level_ready_buffer_screen.tscn")
const continue_screen : PackedScene = preload("res://menus/continue_menu/continue_screen.tscn")
const main_menu : PackedScene = preload("res://menus/main_menu/main_menu.tscn")

func _ready() -> void:
	AudioBus.game_theme.play()
	GameManager.change_level.connect(_on_level_change)
	GameManager.update_floor.emit(GameManager.current_level)
	GameManager.trigger_death.connect(_trigger_death_recountdown)
	_do_level_change.call_deferred(GameManager.current_level)

func _input(event: InputEvent) -> void:
	game_viewport.push_input(event)

func _physics_process(_delta: float) -> void:
	if get_tree().get_first_node_in_group("catto_ball"):
		skybox_camera_3d.global_transform = get_tree().get_first_node_in_group("catto_ball").camera_pivot.transform

func _process(_delta: float) -> void:
	GameManager.update_timer.emit(stage_timer.time_left)

func _on_level_change(level_index : int) -> void:
	GameManager.current_level = level_index
	_do_level_change.call_deferred(level_index)

func _do_level_change(level_index : int) -> void:
	
	var playing_level : Node3D
	if game_viewport.get_child_count() > 0:
		playing_level = game_viewport.get_child(0)
		game_viewport.remove_child.call_deferred(playing_level)
		playing_level.queue_free()
	
	if level_index < GameManager.level_planner.levels.size() and GameManager.total_continues >= 0:
		var next_level_path = GameManager.level_planner.levels[level_index].scene_path
		var packed_scene : PackedScene = load(next_level_path)
		var next_level : Level = packed_scene.instantiate()
		game_viewport.add_child(next_level)
		
		PhysicsServer3D.area_set_param(
		next_level.get_world_3d().space,
		PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR,
		ProjectSettings.get_setting("physics/3d/default_gravity_vector")
		)
		GameManager.update_floor.emit(level_index)
		invoke_buffer()
		#stage_timer.wait_time = 
		stage_timer.start(next_level.total_time_for_stage)
	
	elif GameManager.total_continues < 0:
		#_do_level_change(current_level_index)
		print("TODO RIG UP CONTINUE AND LEADERBOARD ")
	
	catto = get_tree().get_first_node_in_group("catto_ball")
	catto_spawner = get_tree().get_first_node_in_group("level_group").player_spawner

func invoke_buffer() -> void:
	var buffer_screen = ready_buffer_screen.instantiate()
	add_child(buffer_screen)
	await buffer_screen.buffer_finished
	

func _on_stage_timer_timeout() -> void:
	pass # Replace with function body.

func _trigger_death_recountdown() -> void:
	invoke_buffer()
