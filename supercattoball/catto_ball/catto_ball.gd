class_name CattoBall extends RigidBody3D

@onready var camera_rig: Node3D = $CameraYaw/CameraRig
@onready var catto_model: Node3D = $catto
@onready var camera_pivot: Node3D = $CameraYaw/CameraRig/CameraPivot
@onready var pickup_location: Marker3D = $"CameraYaw/CameraRig/CameraPivot/SpringArm3D/Camera3D/Pickup Location"
@onready var camera: Camera3D = $CameraYaw/CameraRig/CameraPivot/SpringArm3D/Camera3D

var max_speed := 30.0          # tune this for your game
var base_pitch := 1.0
var max_pitch := 2.0

func _physics_process(_delta: float) -> void:
	var speed := linear_velocity.length()
	GameManager.update_speed.emit(linear_velocity.length())
	
	if speed > 1.0 and !AudioBus.move.playing:
		AudioBus.move.play()
		AudioBus.wind.play()
	elif speed <= 1.0 and AudioBus.move.playing:
		AudioBus.move.stop()
		AudioBus.wind.stop()
		
	var t : float = clamp(speed / max_speed, 0.0, 1.0)
	AudioBus.move.pitch_scale = lerp(base_pitch, max_pitch, t)
	#AudioBus.wind.volume_db = lerp(-20.0, -5.0, t)
	AudioBus.wind.volume_linear = lerp(AudioBus.wind.volume_linear, t, 0.1)
	
