class_name CattoBall extends RigidBody3D

@onready var camera_rig: Node3D = $CameraYaw/CameraRig
#@onready var catto_model: Node3D = $Catto
@onready var catto_model: Node3D = $cat_model
@onready var camera_pivot: Node3D = $CameraYaw/CameraRig/CameraPivot
@onready var pickup_location: Marker3D = $"CameraYaw/CameraRig/CameraPivot/Camera3D/Pickup Location"


func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	GameManager.update_speed.emit(linear_velocity.length())
#
#var rotation_amount := 1.0
#
#func _physics_process(delta: float) -> void:
	#if Input.is_action_pressed("left"):
		#rotate_y(rotation_amount * delta)
