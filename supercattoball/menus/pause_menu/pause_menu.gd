extends Control

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

#func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("pause"):
		#unpause()

func _on_resume_pressed() -> void:
	unpause()

func _on_settings_pressed() -> void:
	# TODO Create settings menu
	pass # Replace with function body.


func _on_main_menu_pressed() -> void:
	unpause()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://menus/main_menu/main_menu.tscn")

func unpause() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	AudioServer.set_bus_effect_enabled(1, 0, false)
	queue_free()
