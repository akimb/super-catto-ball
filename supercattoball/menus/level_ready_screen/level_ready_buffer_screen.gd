extends Control

@onready var ready_label: Label = $Ready
@onready var go_label: Label = $Go

const transparent : Color = Color("ffffff00")

func _ready() -> void:
	print("level buffer instantiation")
	set_anchors_preset(PRESET_FULL_RECT)
	play_buffer()

func play_buffer() -> void:
	var level : LevelManager = get_parent() # grab the level manager
	
	await level.ready
	var level_group = level.game_viewport.get_child(0)
	#var level_group: Node = null
	#while not level_group:
		#level_group = get_tree().get_first_node_in_group("level_group")
		#await get_tree().process_frame
		
	level_group.set_physics_process(false)
	level.set_process_input(false)
	#if level:
		#get_tree().get_first_node_in_group("level_group").set_physics_process(false)
		#level.set_process_input(false)

	ready_label.show()
	go_label.show()

	ready_label.modulate.a = 0.0
	go_label.modulate.a = 0.0

	# READY fade in
	var t := get_tree().create_tween()
	t.tween_property(ready_label, "modulate:a", 1.0, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await t.finished
	await get_tree().create_timer(0.8).timeout
	ready_label.hide()

	# GO fade in (new tween!)
	t = get_tree().create_tween()
	t.tween_property(go_label, "modulate:a", 1.0, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await t.finished
	await get_tree().create_timer(0.8).timeout
	go_label.hide()

	level_group.set_physics_process(true)
	level.set_process_input(true)

	queue_free()
