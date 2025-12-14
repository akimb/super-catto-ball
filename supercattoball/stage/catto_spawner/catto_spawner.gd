extends Marker3D

@onready var debug_sphere: CSGSphere3D = $"Debug Sphere"

#TODO instantiate player here

func _ready() -> void:
	debug_sphere.hide()
