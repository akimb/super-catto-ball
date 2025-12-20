extends Node3D

@onready var continues: Label = $Control/Continues

const main_menu : PackedScene = preload("res://menus/main_menu/main_menu.tscn")
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_display_continues()
	#GameManager.update_continues.connect(_display_continues)

func _display_continues() -> void:
	continues.text = "continue(s): " + str(GameManager.total_continues)


func _on_yes_pressed() -> void:
	## TODO 
	GameManager.total_continues -= 1
	GameManager.reset_gameplay_for_continue()
	GameManager.load_level_manager()
	pass # Replace with function body.


func _on_no_pressed() -> void:
	GameManager.reset_all_gameplay_data()
	get_tree().change_scene_to_packed(main_menu)
