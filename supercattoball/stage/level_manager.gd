extends Control

@onready var skybox_camera_3d: Camera3D = $SkyboxViewport/SkyboxCamera3D
@onready var game_viewport: SubViewport = $GameViewport


func _ready() -> void:
	GameManager.change_level.connect(_on_level_change)
	GameManager.update_floor.emit(GameManager.current_level)
	#game_viewport.get_child(0).set_process(false) ## TODO this is to prevent input until after the "Ready, GO!" is played

func _input(event: InputEvent) -> void:
	game_viewport.push_input(event)


func _process(_delta: float) -> void:
	if get_tree().get_first_node_in_group("CattoBall"):
		skybox_camera_3d.global_transform = get_tree().get_first_node_in_group("CattoBall").camera_pivot.transform

func _on_level_change(level_index : int) -> void:
	_do_level_change.call_deferred(level_index)

func _do_level_change(level_index : int) -> void:
	var playing_level := game_viewport.get_child(0)
	game_viewport.remove_child(playing_level)
	
	## TODO Handle out of bounds by going to leaderboard scene
	var next_level_path = GameManager.level_planner.levels[level_index].scene_path
	var packed_scene : PackedScene = load(next_level_path)
	var next_level : Level = packed_scene.instantiate()
	game_viewport.add_child(next_level)
	GameManager.update_floor.emit(level_index)
