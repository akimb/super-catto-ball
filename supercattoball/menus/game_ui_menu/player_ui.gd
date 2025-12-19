extends Control

@onready var timer_countdown: Label = $"Timer Countdown"
@onready var fish_count: Label = $"Fish Count"
@onready var score_count: Label = $"Score Count"
@onready var floor_number: Label = $"Floor Number"
@onready var speed: Label = $Speed

@onready var lives: HBoxContainer = $Lives

var imperial : bool = false

const metric_to_imperial_conversion : float = 2.23694

func _ready() -> void:
	GameManager.distance_unit_toggle.connect(_change_distance_units)
	GameManager.update_speed.connect(_display_speed)
	GameManager.update_floor.connect(_display_floor)
	GameManager.update_lives.connect(_display_lives)
	GameManager.update_scores.connect(_display_score)
	score_count.text = str(GameManager.total_score)

func _change_distance_units(imperial_toggle : bool) -> void:
	imperial = imperial_toggle

func _display_speed(units : float) -> void:
	speed.text = "SPEED: "
	if imperial: 
		var imperial_units := metric_to_imperial_conversion * units
		speed.text += str("%.f" % imperial_units) + " mph"
	else:
		speed.text += str("%.f" % units) + " mps"

func _display_floor(floor_num : int) -> void:
	floor_number.text = "FLOOR  " + str(floor_num + 1)

func _display_lives() -> void:
	if lives.get_child_count() > 0:
		lives.get_child(0).queue_free()

func _display_score() -> void:
	score_count.text = str(GameManager.total_score)
