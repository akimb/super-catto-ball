extends Node3D

@export var visual_multiplier := 2.0
@export var max_angle := 12.0
@export var tilt_speed := 6.0

@onready var catto_mesh: Node3D = $"../../catto"

func _process(delta):
	var dir := Input.get_vector("forward", "backward", "right", "left")
	
	var adjusted := catto_mesh.global_basis * Vector3(dir.x, 0.0, dir.y).normalized()
	dir = Vector2(adjusted.x, adjusted.z)
	var target_pitch := deg_to_rad(dir.x * max_angle * visual_multiplier)
	var target_roll  := deg_to_rad(dir.y * max_angle * visual_multiplier)
	
	#rotation.x = lerp_angle(rotation.x, target_pitch, tilt_speed * delta)
	#rotation.z = lerp_angle(rotation.z, target_roll, tilt_speed * delta)
	global_rotation.x = lerp_angle(global_rotation.x, target_pitch, tilt_speed * delta)
	global_rotation.z = lerp_angle(global_rotation.z, target_roll, tilt_speed * delta)
