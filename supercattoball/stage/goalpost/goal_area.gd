extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body == null or !body.is_inside_tree():
		return
	#await get_tree().physics_frame
	if body is CattoBall:
		body.linear_velocity = Vector3.ZERO
		# TODO 
		# play the victory stuff
		print("GOAL!")
		# update scores
		_calculate_time_bonus()
		# prepare the next level
		GameManager.current_level += 1
		_advance_level.call_deferred()
		#GameManager.change_level.emit(GameManager.current_level)
		
		# move to next level scene
		# unload current level

func _advance_level() -> void:
	GameManager.change_level.emit(GameManager.current_level)

func _calculate_time_bonus() -> void:
	pass
