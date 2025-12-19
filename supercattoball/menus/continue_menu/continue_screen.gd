extends Node3D

const main_menu : PackedScene = preload("res://menus/main_menu/main_menu.tscn")
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE




func _on_yes_pressed() -> void:
	pass # Replace with function body.


func _on_no_pressed() -> void:
	GameManager.reset_all_gameplay_data()
	get_tree().change_scene_to_packed(main_menu)
