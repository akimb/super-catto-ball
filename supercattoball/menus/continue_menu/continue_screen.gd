extends Node3D

@onready var continues: Label = $Control/Continues

const leaderboard_screen : PackedScene = preload("res://menus/leaderboard_screen/leaderboard_screen.tscn")
func _ready() -> void:
	GameManager.debug_printer()
	AudioBus.game_ready.stop()
	AudioBus.game_continue.play()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_display_continues()

func _display_continues() -> void:
	continues.text = "continue(s): " + str(GameManager.total_continues)


func _on_yes_pressed() -> void:
	GameManager.total_continues -= 1
	GameManager.reset_gameplay_for_continue()
	GameManager.load_level_manager()


func _on_no_pressed() -> void:
	get_tree().change_scene_to_packed(leaderboard_screen)
	AudioBus.game_theme.stop()
