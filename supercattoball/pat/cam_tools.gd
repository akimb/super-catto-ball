class_name CameraTools extends Node

const WIN_PARTICLES = preload("res://pat/win_particles.tscn")

const intro_height := Vector3(0, 10.0, 0)
const intro_offset := 3.
const intro_duration := 3.

static func intro_cam_setup(tree : SceneTree, level : Node3D):
	var goal :Node3D= tree.get_first_node_in_group('goal')
	#var start :Node3D= tree.get_first_node_in_group('start')
	var player :CattoBall= tree.get_first_node_in_group('catto_ball')
	
	# Find the ground position of the player start
	var space_state = player.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(player.global_position, player.global_position - Vector3(0, 100, 0))
	query.collide_with_areas = true
	query.collision_mask = 1
	var result = space_state.intersect_ray(query)
	var start_pos :Vector3= result.position
	
	var cam := Camera3D.new()
	var pivot := Node3D.new()
	pivot.name = 'intro_pivot'
	var mid_point := (goal.global_position + start_pos) / 2.
	var to_goal :Vector3= (goal.global_position - start_pos).normalized()

	# Figure out the player's camera position
	var player_cam :Camera3D= player.find_child('Camera3D')
	const player_cam_height := Vector3(0, 1.074, 0)  # The height of the camera from the ground, hardcoded since it shouldn't change at this point
	var player_cam_pos := Vector3(player_cam.global_position.x, start_pos.y + player_cam_height.y, player_cam.global_position.z) # Based off of start because player hasn't fallen yet

	# The end point of the pivot needs to be at the height of the player camera for smoothness
	var pivot_end_pos := Vector3( mid_point.x, start_pos.y + player_cam_height.y, mid_point.z )
	var pivot_start_pos := pivot_end_pos + intro_height
	
	level.add_child(pivot)
	pivot.add_child(cam)
	pivot.global_position = pivot_start_pos
	cam.global_position = start_pos + intro_height + (-to_goal * intro_offset)
	cam.current = true
	
	# The look at needs to end matching the player
	var final_look_target = Geometry3D.get_closest_point_to_segment_uncapped(mid_point, player_cam_pos,  player_cam_pos - player_cam.global_basis.z)
	
	var tween := tree.create_tween()
	tween.set_parallel()
	tween.tween_property(pivot, 'global_position', pivot_end_pos, intro_duration)
	tween.tween_property(pivot, 'global_rotation:y', TAU, intro_duration)
	
	tween.tween_property(cam, 'global_position', player_cam_pos, .5).set_delay( intro_duration - .5)
	
	if not cam:
		return
	
	tween.tween_method(
		func(val : Vector3):
			cam.look_at(val),
		mid_point + player_cam_height,
		final_look_target,
		intro_duration
	)
	
	await tween.finished
	player_cam.current = true
	pivot.queue_free()


const outro_spin_duration := 0.75
const outro_rise_duration := 1.5

static func outro_cam_setup(level : Node3D):
	#var goal :Node3D= tree.get_first_node_in_group('goal')
	#var start :Node3D= tree.get_first_node_in_group('start')
	var player :CattoBall= level.get_tree().get_first_node_in_group('catto_ball')
	var player_cam :Camera3D= player.find_child('Camera3D')
	
	var cam := Camera3D.new()
	var pivot := Node3D.new()
	pivot.name = 'outro_pivot'
	
	level.add_child(pivot)
	pivot.add_child(cam)
	
	var particles := WIN_PARTICLES.instantiate()
	player.add_child(particles)
	
	pivot.global_position = player.global_position
	
	cam.global_transform = player_cam.global_transform
	cam.current = true
	
	var tween := level.create_tween()
	tween.tween_property( pivot, 'rotation:y', TAU, outro_spin_duration)

	var initial_point = Geometry3D.get_closest_point_to_segment_uncapped(player.global_position, player_cam.global_position, player_cam.global_position + player_cam.global_basis.z)
	
	tween.set_parallel()
	tween.tween_property( cam, 'position', cam.position + cam.basis.z * 2., outro_spin_duration)
	tween.set_parallel(false)

	tween.tween_method(
		func(val):cam.look_at(val),
		initial_point,
		initial_point + Vector3(0, 10, 0),
		outro_rise_duration
	)
	
	tween.set_parallel()
	tween.tween_property( player, 'global_position', player.global_position  + Vector3(0, 20, 0), outro_rise_duration).set_ease(Tween.EASE_IN)
	
	#tween.finished.connect( func():pivot.queue_free() )
	return tween
	
