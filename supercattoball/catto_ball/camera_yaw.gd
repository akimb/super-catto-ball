extends Node3D

#@export var follow_speed := 8.0
#
#func _process(delta):
	#global_position = global_position.lerp(
		#owner.global_position,
		#follow_speed * delta
	#)
#
#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		#rotate_x(event.relative.y * GameManager.mouse_sensitivity)
		#clampf(rotation_degrees.x, -15.0, 15.0)
