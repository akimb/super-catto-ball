class_name Level extends Node3D

@export var player_spawner : Marker3D
@onready var world_environment: WorldEnvironment = $WorldEnvironment

var base_gravity = ProjectSettings.get_setting("physics/3d/default_gravity_vector")
var catto_ball : CattoBall
const catto_ball_player : PackedScene = preload("res://catto_ball/catto_ball.tscn")

var mouse_sensitivity = 0.001

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	catto_ball = catto_ball_player.instantiate()
	add_child(catto_ball)
	catto_ball.global_transform = player_spawner.global_transform

func _physics_process(_delta):
	var input := Input.get_vector("forward", "backward", "right", "left")
	#var forward := Input.get_axis("forward", "backward")
	#var right := Input.get_axis("left", "right")
	#
	#var forward_vec := Vector3.FORWARD * forward
	#var right_vec := Vector3.RIGHT * right
	#
	#var dir := (forward_vec + right_vec).normalized()
	#
	#dir = catto.basis * dir
	#
	#var target_basis := Basis.IDENTITY
	#if dir:
		#var dir_basis := Basis.looking_at(dir, Vector3.UP)
		#var down_basis := Basis.IDENTITY.rotated(Vector3.RIGHT, 0.25 * TAU)
		#target_basis = down_basis.slerp(dir_basis, 0.2)
	
	#var forward := -catto.camera_pivot.global_transform.basis.z
	#var right := catto.camera_pivot.global_transform.basis.x
#
	#var gravity_dir := (forward * input.x + right * input.y - Vector3.UP).normalized()
	#input = input.rotated(-catto_ball.camera_pivot.rotation.y)
	var dir = catto_ball.catto_model.global_basis * Vector3(input.y, -1.0, -input.x).normalized() * 10
	#var tilt := Vector3(dir.z, -1.0, dir.x).normalized()

	#PhysicsServer3D.area_set_param(
		#get_world_3d().space,
		#PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR,
		#target_basis * base_gravity
	#)
	PhysicsServer3D.area_set_param(
		get_world_3d().space,
		PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR,
		dir * base_gravity.length()
	)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		catto_ball.camera_pivot.rotate_y(-event.relative.x * mouse_sensitivity)
		catto_ball.catto_model.rotate_y(-event.relative.x * mouse_sensitivity)

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
