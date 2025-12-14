extends Node3D

@export var follow_speed := 8.0

func _process(delta):
	global_position = global_position.lerp(
		owner.global_position,
		follow_speed * delta
	)
