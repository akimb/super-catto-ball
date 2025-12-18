extends Node

@export var test : float 
var total_score : int = 0
var total_lives : int = 3

var current_level : LevelPlanner = preload("res://levels/manager/level_planner.tres")

func _ready() -> void:
	print(current_level.levels[0].scene_path)
	print(current_level.levels[1].scene_path)
