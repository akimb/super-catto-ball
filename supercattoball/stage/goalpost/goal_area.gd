extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body is CattoBall:
		# TODO 
		# play the victory stuff
		# update scores
		# prepare the next level
		# move to next level scene
		# unload current level
		print("SUCCESS")
