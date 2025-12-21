class_name LevelManager extends Control

@onready var player_ui: Control = $"Player UI"
@onready var skybox_camera_3d: Camera3D = $SkyboxViewport/SkyboxCamera3D
@onready var game_viewport: SubViewport = $GameViewport
@onready var stage_timer: Timer = $"Stage Timer"

var current_level_index : int = 0
var catto : CattoBall 
var catto_spawner : Marker3D
var stage_time_total : float

var current_loaded_level : Level

var current_fish : int
var current_score : int

var last_second_left := -1
var last10_sounds : Array[AudioStreamPlayer] = [
	AudioBus.countdown_10,
	AudioBus.countdown_9,
	AudioBus.countdown_8,
	AudioBus.countdown_7,
	AudioBus.countdown_6,
	AudioBus.countdown_5,
	AudioBus.countdown_4,
	AudioBus.countdown_3,
	AudioBus.countdown_2,
	AudioBus.countdown_1
]

const ready_buffer_screen : PackedScene = preload("res://menus/level_ready_screen/level_ready_buffer_screen.tscn")
const continue_screen : PackedScene = preload("res://menus/continue_menu/continue_screen.tscn")
const main_menu : PackedScene = preload("res://menus/main_menu/main_menu.tscn")
const leaderboard_screen : PackedScene = preload("res://menus/leaderboard_screen/leaderboard_screen.tscn")

func _ready() -> void:
	AudioBus.game_theme.play()
	GameManager.total_score = current_score
	GameManager.total_fish = current_fish
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
	if stage_timer.is_stopped():
		return
	
	GameManager.update_timer.emit(stage_timer.time_left)
	var seconds_left := int(stage_timer.time_left)
	
	if seconds_left != last_second_left:
		last_second_left = seconds_left
		
		if seconds_left <= 10 and seconds_left > 0:
			play_last10_sound(seconds_left)

func play_last10_sound(seconds_left:int):
	var idx := 10 - seconds_left
	if idx >= 0 and idx < last10_sounds.size():
		last10_sounds[idx].play()

func _on_level_change(level_index : int) -> void:
	stage_timer.stop()
	GameManager.current_level = level_index
	_do_level_change.call_deferred(level_index)


static var show_new_level := true ## Needed since goal area also updates current_level

func _do_level_change(level_index : int) -> void:
	current_score = GameManager.total_score
	current_fish = GameManager.total_fish
	var playing_level : Node3D
	
	if game_viewport.get_child_count() > 0:
		playing_level = game_viewport.get_child(0)
		#game_viewport.remove_child.call_deferred(playing_level)
		
		if show_new_level:
			var win_screen = load('res://pat/menu/level_win.tscn').instantiate()
			get_tree().current_scene.add_child(win_screen)
			await win_screen.setup(self)
			
			await CameraTools.outro_cam_setup(playing_level).finished
			win_screen.queue_free()
		
		playing_level.queue_free()
	
	if level_index < GameManager.level_planner.levels.size() and GameManager.total_continues >= 0:
		var next_level_path = GameManager.level_planner.levels[level_index].scene_path
		var packed_scene : PackedScene = load(next_level_path)
		var next_level : Level = packed_scene.instantiate()
		game_viewport.add_child(next_level)
		current_loaded_level = next_level
		
		PhysicsServer3D.area_set_param(
		next_level.get_world_3d().space,
		PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR,
		ProjectSettings.get_setting("physics/3d/default_gravity_vector")
		)
		
		GameManager.update_floor.emit(level_index)
		GameManager.get_stage_time.emit(next_level.total_time_for_stage)
		stage_time_total = next_level.total_time_for_stage
		stage_timer.wait_time = stage_time_total
		GameManager.update_timer.emit(stage_time_total)
		
		if show_new_level:
			set_process_input(false)
			get_tree().process_frame.connect( func(): CameraTools.intro_cam_setup(get_tree(), next_level), CONNECT_ONE_SHOT)
			await get_tree().create_timer(2.).timeout
		
		await invoke_buffer()
		stage_timer.start(stage_time_total)
	elif level_index >= GameManager.level_planner.levels.size():
		get_tree().change_scene_to_packed(leaderboard_screen)
	elif GameManager.total_continues < 0:
		get_tree().change_scene_to_packed(leaderboard_screen)
	
	show_new_level = false
	#catto = get_tree().get_first_node_in_group("catto_ball")
	#catto_spawner = get_tree().get_first_node_in_group("level_group").player_spawner

func invoke_buffer() -> void:
	var buffer_screen = ready_buffer_screen.instantiate()
	add_child(buffer_screen)
	await buffer_screen.buffer_finished

func _on_stage_timer_timeout() -> void:
	GameManager.total_lives -= 1
	GameManager.update_lives.emit()
	GameManager.trigger_death.emit()
	
	if GameManager.total_lives <= 0 and GameManager.total_continues > 0:
		GameManager.update_continues.emit()
		get_tree().change_scene_to_packed.call_deferred(continue_screen)

func _trigger_death_recountdown() -> void:
	AudioBus.howl.play()
	
	GameManager.total_score = current_score
	GameManager.total_fish = current_fish
	GameManager.update_scores.emit()
	GameManager.update_fish.emit()
	
	stage_timer.stop()
	stage_timer.wait_time = stage_time_total
	GameManager.update_timer.emit(stage_time_total)
	_do_level_change.call_deferred(GameManager.current_level)
	
	await invoke_buffer()
	stage_timer.start(stage_time_total)
