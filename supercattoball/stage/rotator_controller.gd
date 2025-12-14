extends Node3D

var base_gravity = ProjectSettings.get_setting("physics/3d/default_gravity_vector")
var catto : CattoBall

func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	catto = get_node("Catto Ball")

func _physics_process(_delta):
	var input := Input.get_vector("forward", "backward", "right", "left")
	var tilt := Vector3(input.y, -1.0, -input.x).normalized()

	PhysicsServer3D.area_set_param(
		get_world_3d().space,
		PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR,
		tilt * base_gravity.length()
	)

## Deprecated code
#@export var max_angle : float = 15.0
#@export var stage_components : Array[Node3D] = []
#
#var tilt_lerp_weight := 0.05
#
#
#func _physics_process(_delta: float) -> void:
	#var tilt_dir := Input.get_vector("forward", "backward", "right", "left")
	#tilt_lerp(tilt_dir)
#
#
#func tilt_lerp(dir : Vector2) -> void:
	#var x_rot := -dir.x * max_angle
	#var z_rot := -dir.y * max_angle
	#
	#var current_stage_rotation : Vector3 = rotation_degrees
	#current_stage_rotation.x = lerpf(current_stage_rotation.x, x_rot, tilt_lerp_weight)
	#current_stage_rotation.z = lerpf(current_stage_rotation.z, z_rot, tilt_lerp_weight)
	#rotation_degrees = current_stage_rotation
