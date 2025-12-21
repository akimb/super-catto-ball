extends Control


func _ready():
	%Time.self_modulate.a = 0
	%Bonus.self_modulate.a = 0


func setup(level_manager : LevelManager):
	var playing_level = level_manager.game_viewport.get_child(0)
	
	var catto :CattoBall= get_tree().get_first_node_in_group("catto_ball")
	catto.freeze = true
	
	var total_time: float = playing_level.total_time_for_stage
	#var time_taken: float = total_time - level_manager.stage_timer.time_left
	var time_taken: float = total_time -  float(level_manager.find_child('Timer Countdown').text)
	var pct = (time_taken / total_time )
	
	var bonus_msg := ''
	
	match pct:
		var x when x < .2:
			AudioBus.bonus.play()
			bonus_msg = ' 1000   Purrfection!'
			GameManager.total_score += 1000
		var x when x < .5:
			AudioBus.bonus.play()
			bonus_msg = ' 500   Excellent'
			GameManager.total_score += 500
		var x when x < .75:
			AudioBus.bonus.play()
			bonus_msg = ' 200   Good job'
			GameManager.total_score += 200
		_:
			bonus_msg = ' Meh-ow'
	
	await get_tree().create_timer(1.0).timeout
	
	%TimeEmitter.emitting = true
	await %TimeEmitter.finished
	%Time.text += ' %s' % (time_taken)
	create_tween().tween_property(%Time, 'self_modulate:a', 1.0, .25)
	
	%BonusEmitter.emitting = true
	await %BonusEmitter.finished
	%Bonus.text += ' ' + bonus_msg
	create_tween().tween_property(%Bonus, 'self_modulate:a', 1.0, .25)
	GameManager.update_scores.emit()
	
	await get_tree().create_timer(1.0).timeout
