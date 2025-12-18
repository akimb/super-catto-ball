class_name Level extends Node3D

@export var player_spawner : Marker3D
@onready var world_environment: WorldEnvironment = $WorldEnvironment

var base_gravity = ProjectSettings.get_setting("physics/3d/default_gravity_vector")
var catto : CattoBall
const catto_ball_player : PackedScene = preload("res://catto_ball/catto_ball.tscn")

var mouse_sensitivity = 0.001

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	catto = catto_ball_player.instantiate()
	add_child(catto)
	catto.global_transform = player_spawner.global_transform

func _physics_process(_delta):
	var input := Input.get_vector("forward", "backward", "right", "left")
	input = input.rotated(-catto.camera_pivot.rotation.y)
	var tilt := Vector3(input.y, -1.0, -input.x).normalized()

	PhysicsServer3D.area_set_param(
		get_world_3d().space,
		PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR,
		tilt * base_gravity.length()
	)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		catto.camera_pivot.rotate_y(-event.relative.x * mouse_sensitivity)
		catto.catto_model.rotate_y(-event.relative.x * mouse_sensitivity)

#func _process(_delta: float) -> void:
	#world_environment.environment.sky_rotation = catto.camera_rig.rotation

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
