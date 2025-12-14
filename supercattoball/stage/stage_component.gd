class_name StageComponent extends StaticBody3D

enum STAGE_MATERIAL {
	ICE,
	SNOW
}
@export var display_debug : bool = false
@export var stage_material : STAGE_MATERIAL

var stage_meshes : Array[MeshInstance3D] = []
var stage_colliders : Array[CollisionShape3D] = []

const ICE_PHYSICS = preload("uid://6dhw7y5cfehj")
const SNOW_PHYSICS = preload("uid://cdwmpdm0ynb35")

func _ready() -> void:
	
	match stage_material:
		STAGE_MATERIAL.SNOW:
			physics_material_override = ICE_PHYSICS
		STAGE_MATERIAL.ICE:
			physics_material_override = SNOW_PHYSICS
	
	for child in get_children():
		if child is MeshInstance3D:
			stage_meshes.append(child)
		elif child is CollisionShape3D:
			stage_colliders.append(child)
	
	if display_debug: 
		print(physics_material_override.resource_name)
		print(stage_meshes)
		print(stage_colliders)
