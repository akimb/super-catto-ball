class_name LevelManager extends Control

@onready var skybox_camera_3d: Camera3D = $SkyboxViewport/SkyboxCamera3D
@onready var game_viewport: SubViewport = $GameViewport

var catto: CattoBall
var catto_spawner: Marker3D
var current_level: Level

const READY_BUFFER := preload("res://menus/level_ready_screen/level_ready_buffer_screen.tscn")
const CONTINUE_SCREEN := preload("res://menus/continue_menu/continue_screen.tscn")
const MAIN_MENU := preload("res://menus/main_menu/main_menu.tscn")


func _ready() -> void:
	# readies signal to add levels to viewport
	GameManager.change_level.connect(_on_level_change)
	# updates the floor number in ui
	GameManager.update_floor.emit(GameManager.current_level)
	invoke_buffer_scene()
	
	# first level is added to scene
	_change_level_deferred(GameManager.current_level)


func _input(event: InputEvent) -> void:
	game_viewport.push_input(event)


func _physics_process(_delta: float) -> void:
	if catto and catto.is_inside_tree():
		skybox_camera_3d.global_transform = catto.camera_pivot.transform


func _on_level_change(level_index: int) -> void:
	GameManager.current_level = level_index
	_change_level_deferred(level_index)


func _change_level_deferred(level_index: int) -> void:
	_do_level_change.call_deferred(level_index)
	#call_deferred("_do_level_change", level_index)


func _do_level_change(level_index: int) -> void:
	print("level change")
	var playing_level : Node3D
	if game_viewport.get_child_count() > 0:
		playing_level = game_viewport.get_child(0)
		game_viewport.remove_child.call_deferred(playing_level)
		
	if current_level and current_level.is_inside_tree():
		current_level.queue_free()
		await get_tree().process_frame
#
	#if level_index >= GameManager.level_planner.levels.size():
		#print("TODO: Leaderboard or ending")
		#return
#
	#if GameManager.total_continues < 0:
		#print("TODO: handle no-continue path")
		#return

	# Load next level
	var path := GameManager.level_planner.levels[level_index].scene_path
	var packed: PackedScene = load(path)
	current_level = packed.instantiate()

	game_viewport.add_child(current_level)
	await current_level.ready
	await get_tree().process_frame
	
	invoke_buffer_scene()
	
	catto = get_tree().get_first_node_in_group("catto_ball")
	var level_group = get_tree().get_first_node_in_group("level_group")

	if level_group:
		catto_spawner = level_group.player_spawner
	
	GameManager.update_floor.emit(level_index)
	
func invoke_buffer_scene() -> void:
	var spawn_ready_buffer = READY_BUFFER.instantiate()
	add_child(spawn_ready_buffer)
#extends Control
#
#@onready var skybox_camera_3d: Camera3D = $SkyboxViewport/SkyboxCamera3D
#@onready var game_viewport: SubViewport = $GameViewport
#
#var current_level_index : int = 0
#var catto : CattoBall 
#var catto_spawner : Marker3D
#
#const ready_buffer_screen : PackedScene = preload("res://menus/level_ready_screen/level_ready_buffer_screen.tscn")
#const continue_screen : PackedScene = preload("res://menus/continue_menu/continue_screen.tscn")
#const main_menu : PackedScene = preload("res://menus/main_menu/main_menu.tscn")
#
#func _ready() -> void:
	#GameManager.change_level.connect(_on_level_change)
	#GameManager.update_floor.emit(GameManager.current_level)
	##GameManager.trigger_death.connect(_trigger_death)
	#var buffer_screen = ready_buffer_screen.instantiate()
	#add_child(buffer_screen)
	#_do_level_change.call_deferred(GameManager.current_level)
	#
	##game_viewport.get_child(0).set_process(false) ## TODO this is to prevent input until after the "Ready, GO!" is played
#
#func _input(event: InputEvent) -> void:
	#game_viewport.push_input(event)
#
#func _physics_process(_delta: float) -> void:
	#if get_tree().get_first_node_in_group("catto_ball"):
		#skybox_camera_3d.global_transform = get_tree().get_first_node_in_group("catto_ball").camera_pivot.transform
#
#func _on_level_change(level_index : int) -> void:
	##current_level_index = level_index
	#GameManager.current_level = level_index
	#_do_level_change.call_deferred(level_index)
#
#func _do_level_change(level_index : int) -> void:
	#var playing_level : Node3D
	#if game_viewport.get_child_count() > 0:
		#playing_level = game_viewport.get_child(0)
		#game_viewport.remove_child.call_deferred(playing_level)
	#
	### TODO Handle out of bounds by going to leaderboard scene
	#if level_index < GameManager.level_planner.levels.size() and GameManager.total_continues >= 0:
		#var next_level_path = GameManager.level_planner.levels[level_index].scene_path
		#var packed_scene : PackedScene = load(next_level_path)
		#var next_level : Level = packed_scene.instantiate()
		#game_viewport.add_child(next_level)
		#await next_level.ready
		#var buffer_screen = ready_buffer_screen.instantiate()
		#add_child(buffer_screen)
		#GameManager.update_floor.emit(level_index)
	#
	#elif GameManager.total_continues < 0:
		##_do_level_change(current_level_index)
		#print("TODO RIG UP CONTINUE AND LEADERBOARD ")
	#
	#catto = get_tree().get_first_node_in_group("catto_ball")
	#catto_spawner = get_tree().get_first_node_in_group("level_group").player_spawner
#
#
#func _on_stage_timer_timeout() -> void:
	#pass # Replace with function body.
#
#func _trigger_death() -> void:
	#catto.global_transform = catto_spawner.global_transform
	### TODO set process false until after countdown is reinvoked
	#catto.linear_velocity = Vector3.ZERO
	#GameManager.total_lives -= 1
	#
	#if GameManager.total_lives <= 0 and GameManager.total_continues > 0:
		#GameManager.update_continues.emit()
		#get_tree().change_scene_to_packed.call_deferred(continue_screen)
		#
	#elif GameManager.total_lives <= 0 and GameManager.total_continues <= 0:
		#GameManager.reset_all_gameplay_data()
		#get_tree().change_scene_to_packed(main_menu)
	#else:
		#GameManager.update_lives.emit()
