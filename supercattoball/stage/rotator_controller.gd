class_name Level extends Node3D

@export var total_time_for_stage := 60.0
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
	var dir = catto_ball.catto_model.global_basis * Vector3(input.y, -1.0, -input.x).normalized()

	PhysicsServer3D.area_set_param(
		get_world_3d().space,
		PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR,
		dir * base_gravity.length()
	)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		catto_ball.camera_pivot.rotate_y(-event.relative.x * mouse_sensitivity)
		catto_ball.catto_model.rotate_y(-event.relative.x * mouse_sensitivity)
