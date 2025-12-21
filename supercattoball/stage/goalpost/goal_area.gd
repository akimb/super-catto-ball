extends Area3D

var stage_level_time : float 
var curr_level_time : float = 0.0

func _ready() -> void:
	GameManager.get_stage_time.connect(_update_stage_time)
	GameManager.update_timer.connect(_get_current_time)

func _on_body_entered(body: Node3D) -> void:
	if body == null or !body.is_inside_tree():
		return
	
	if body is CattoBall:
		AudioBus.goal.play()
		AudioBus.applause.play()
		body.linear_velocity = Vector3.ZERO
		_calculate_time_bonus()
		sum_total_time()
		GameManager.current_level += 1
		LevelManager.show_new_level = true
		_advance_level.call_deferred()

func _get_current_time(time : float) -> void:
	curr_level_time = time

func sum_total_time() -> void:
	GameManager.total_time += stage_level_time - curr_level_time

func _advance_level() -> void:
	GameManager.change_level.emit(GameManager.current_level)

func _update_stage_time(time) -> void:
	stage_level_time = time

func _calculate_time_bonus() -> void:
	pass
