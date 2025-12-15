extends Node3D

@export var visual_multiplier := 1.0
@export var max_angle := 12.0
@export var tilt_speed := 6.0

var mouse_sensitivity = 0.002

func _process(delta):
	var dir := Input.get_vector("forward", "backward", "right", "left")

	var target_pitch := deg_to_rad(dir.x * max_angle * visual_multiplier)
	var target_roll  := deg_to_rad(dir.y * max_angle * visual_multiplier)

	global_rotation.x = lerp_angle(global_rotation.x, target_pitch, tilt_speed * delta)
	global_rotation.z = lerp_angle(global_rotation.z, target_roll, tilt_speed * delta)
	

#func _input(event):
	#if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		#owner.rotate_y(-event.relative.x * mouse_sensitivity)
