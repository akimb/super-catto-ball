extends Node

#region Game Metadata
@warning_ignore("unused_signal") signal change_level
@warning_ignore("unused_signal") signal update_lives
@warning_ignore("unused_signal") signal update_scores
@warning_ignore("unused_signal") signal update_fish
@warning_ignore("unused_signal") signal update_speed
@warning_ignore("unused_signal") signal update_floor
#endregion

#region Game Settings
@warning_ignore("unused_signal") signal distance_unit_toggle
#endregion

var total_score : int = 0
var total_fish : int = 0
var total_lives : int = 3

var level_planner : LevelPlanner = preload("res://levels/manager/level_planner.tres")
var current_level : int = 0
var toggle_metric_or_imperial : bool = false

const PAUSE_MENU : PackedScene = preload("res://menus/pause_menu/pause_menu.tscn")
const LEVEL_MANAGER : PackedScene = preload("res://stage/level_manager.tscn")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause") and get_tree().root.has_node("LevelManager"):
		if not get_tree().paused:
			var p := PAUSE_MENU.instantiate()
			get_tree().root.add_child(p)
			get_tree().paused = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func load_level_manager() -> void:
	get_tree().change_scene_to_packed(LEVEL_MANAGER)
