extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body is CattoBall:
		# TODO 
		# play the victory stuff
		print("GOAL!")
		# update scores
		_calculate_time_bonus()
		# prepare the next level
		GameManager.current_level += 1
		GameManager.change_level.emit(GameManager.current_level)
		
		# move to next level scene
		# unload current level

func _calculate_time_bonus() -> void:
	pass
