extends Area3D

@export var score_contribution := 200
@export var bob_amplitude := 0.1
@export var bob_speed := 2.0
@export var rotation_speed := 20.0
@onready var fish_mesh : MeshInstance3D = $fish

var starting_mesh_pos_y : float

func _ready() -> void:
	starting_mesh_pos_y = fish_mesh.global_position.y

func _process(delta: float) -> void:
	fish_mesh.global_position.y = starting_mesh_pos_y + sin(Time.get_ticks_msec() / 1000.0 * bob_speed) * bob_amplitude
	fish_mesh.rotation_degrees.y += rotation_speed * delta

func _on_body_entered(body: CattoBall) -> void:
	if body:
		rotation_speed *= 2.0
		GameManager.total_score += score_contribution
		GameManager.update_scores.emit()
		var fish_tween := get_tree().create_tween()
		fish_tween.tween_property(fish_mesh, "global_position", body.pickup_location.global_position, 0.5)
		await fish_tween.finished
		queue_free()
		#fish_mesh.global_position.slerp(body.pickup_location.global_position, 0.5)
