extends Node3D

@onready var title_screen: Control = $"Title Screen"
@onready var main_menu_screen: Control = $"Main Menu Screen"
@onready var how_to_play_screen: Control = $"How to Play Screen"

@onready var title_camera: Camera3D = $"Title Camera"
@onready var title_marker: Marker3D = $"Title Marker"
@onready var how_to_play_marker: Marker3D = $"How to Play Marker"

var screens : Array[Control] = []

const START_GAME : PackedScene = preload("res://levels/track1/track_1.tscn")

func _ready() -> void:
	for child in get_children():
		if child is Control:
			screens.append(child)
	
	AudioBus.main_menu_theme.play()
	bring_up_active_screen(title_screen)

func interpolate_cameras(cam_marker : Marker3D, from_ui : Control, to_ui : Control, fov : float = 75.0):
	from_ui.visible = false
	var pass_camera = get_tree().create_tween()
	pass_camera.set_parallel()
	pass_camera.tween_property(title_camera, "global_transform", cam_marker.global_transform, 0.75).set_trans(Tween.TRANS_CUBIC)
	pass_camera.tween_property(title_camera, "fov", fov, 0.75).set_trans(Tween.TRANS_CUBIC)
	await pass_camera.finished
	to_ui.visible = true

func _on_play_pressed() -> void:
	bring_up_active_screen(main_menu_screen)

func _on_roll_pressed() -> void:
	get_tree().change_scene_to_packed(START_GAME)

func _on_how_to_play_pressed() -> void:
	interpolate_cameras(how_to_play_marker, main_menu_screen, how_to_play_screen)

func bring_up_active_screen(desired_screen : Control) -> void:
	for screen in screens:
		if screen == desired_screen:
			screen.show()
		else:
			screen.hide()

func _on_how_to_play_back_pressed() -> void:
	interpolate_cameras(title_marker, how_to_play_screen, main_menu_screen)
