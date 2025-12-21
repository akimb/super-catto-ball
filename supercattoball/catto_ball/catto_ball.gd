class_name CattoBall extends RigidBody3D

@onready var camera_rig: Node3D = $CameraYaw/CameraRig
@onready var catto_model: Node3D = $catto
@onready var camera_pivot: Node3D = $CameraYaw/CameraRig/CameraPivot
@onready var pickup_location: Marker3D = $"CameraYaw/CameraRig/CameraPivot/Camera3D/Pickup Location"
@onready var camera: Camera3D = $CameraYaw/CameraRig/CameraPivot/Camera3D


func _physics_process(_delta: float) -> void:
	GameManager.update_speed.emit(linear_velocity.length())
