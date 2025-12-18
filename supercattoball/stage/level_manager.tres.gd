
extends Control

@onready var skybox_camera_3d: Camera3D = $SkyboxViewport/SkyboxCamera3D
@onready var game_viewport: SubViewport = $GameViewport
@onready var track_1: Node3D = $"GameViewport/Track 1"

func _input(event: InputEvent) -> void:
	game_viewport.push_input(event)


func _process(_delta: float) -> void:
	if get_tree().get_nodes_in_group("CattoBall").front():
		skybox_camera_3d.global_transform = get_tree().get_nodes_in_group("CattoBall").front().camera_pivot.transform
