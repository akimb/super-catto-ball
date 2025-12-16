extends Node3D

@export var island_meshes : Array[MeshInstance3D] = []
@export var rotation_speed : float = 10.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	for islands in island_meshes:
		islands.rotation_degrees.y += rotation_speed * delta
