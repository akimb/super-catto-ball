extends Area3D

@export var catto_spawner : Marker3D
@onready var debug_shape: MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	debug_shape.hide()

func _on_body_entered(body: CattoBall) -> void:
	
	if body:
		body.global_transform = catto_spawner.global_transform
		## TODO set process false until after countdown is reinvoked
		body.linear_velocity = Vector3.ZERO
