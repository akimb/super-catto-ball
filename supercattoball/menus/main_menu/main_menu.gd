extends Node3D

@onready var title_screen: Control = $"Title Screen"
@onready var main_menu_screen: Control = $"Main Menu Screen"
@onready var how_to_play_screen: Control = $"How to Play Screen"
@onready var credits_screen: Control = $"Credits Screen"
@onready var settings_screen: Control = $"Settings Screen"

@onready var title_camera: Camera3D = $"Title Camera"
@onready var title_marker: Marker3D = $"Title Marker"
@onready var how_to_play_marker: Marker3D = $"How to Play Marker"
@onready var credits_marker: Marker3D = $"Credits Marker"

var screens : Array[Control] = []

const START_GAME : PackedScene = preload("res://stage/level_manager.tscn")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	for child in get_children():
		if child is Control:
			screens.append(child)
	
	AudioBus.super_catto_ball.play()
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

func bring_up_active_screen(desired_screen : Control) -> void:
	for screen in screens:
		if screen == desired_screen:
			screen.show()
		else:
			screen.hide()

func _on_play_pressed() -> void:
	bring_up_active_screen(main_menu_screen)

func _on_roll_pressed() -> void:
	GameManager.load_level_manager()
	AudioBus.main_menu_theme.stop()

func _on_how_to_play_pressed() -> void:
	interpolate_cameras(how_to_play_marker, main_menu_screen, how_to_play_screen)

func _on_how_to_play_back_pressed() -> void:
	interpolate_cameras(title_marker, how_to_play_screen, main_menu_screen)

func _on_settings_pressed() -> void:
	bring_up_active_screen(settings_screen)

func _on_settings_back_pressed() -> void:
	bring_up_active_screen(main_menu_screen)

func _on_credits_pressed() -> void:
	interpolate_cameras(credits_marker, main_menu_screen, credits_screen)

func _on_credits_back_pressed() -> void:
	interpolate_cameras(title_marker, credits_screen, main_menu_screen)

func _on_quit_pressed() -> void:
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()


func _on_save_pressed() -> void:
	pass # Replace with function body.
