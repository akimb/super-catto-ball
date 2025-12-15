extends Area3D



func _on_body_entered(body: CattoBall) -> void:
	if body:
		print("DEATH")
