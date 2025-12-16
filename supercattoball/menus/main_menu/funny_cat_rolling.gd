extends MeshInstance3D

@export var rotation_speed : float = 50.0
@export var rotate_around_x : bool = false
@export var rotate_around_y : bool = false
@export var rotate_around_z : bool = false

func _process(delta: float) -> void:
	if rotate_around_x:
		rotation_degrees.x += rotation_speed * delta
	elif rotate_around_y:
		rotation_degrees.y += rotation_speed * delta
	elif rotate_around_z:
		rotation_degrees.z += rotation_speed * delta
	else:
		return
