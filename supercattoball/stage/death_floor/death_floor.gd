extends Area3D

@export var catto_spawner : Marker3D
@onready var debug_shape: MeshInstance3D = $MeshInstance3D

const continue_screen : PackedScene = preload("res://menus/continue_menu/continue_screen.tscn")
const main_menu : PackedScene = preload("res://menus/main_menu/main_menu.tscn")

func _ready() -> void:
	debug_shape.hide()

func _on_body_entered(body: CattoBall) -> void:
	AudioBus.howl.play()
	if body:
		GameManager.trigger_death.emit()
		body.global_transform = catto_spawner.global_transform
		body.linear_velocity = Vector3.ZERO
		GameManager.total_lives -= 1
		
		if GameManager.total_lives <= 0 and GameManager.total_continues > 0:
			GameManager.update_continues.emit()
			get_tree().change_scene_to_packed.call_deferred(continue_screen)
			
		elif GameManager.total_lives <= 0 and GameManager.total_continues <= 0:
			GameManager.reset_all_gameplay_data()
			get_tree().change_scene_to_packed.call_deferred(main_menu)
		else:
			GameManager.update_lives.emit()
