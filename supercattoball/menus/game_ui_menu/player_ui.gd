extends Control

@onready var timer_countdown: Label = $"Timer Countdown"
@onready var fish_count: Label = $"Fish Count"
@onready var score_count: Label = $"Score Count"
@onready var floor_number: Label = $"Floor Number"
@onready var speed: Label = $Speed

@onready var lives: HBoxContainer = $Lives

var use_imperial : bool = false
var last_speed := 0.0

const metric_to_imperial_conversion : float = 2.23694
const cat_life : PackedScene = preload("uid://dvsyc38cp3kdi")

func _ready() -> void:
	_change_distance_units()
	GameManager.update_speed.connect(_display_speed)
	GameManager.update_floor.connect(_display_floor)
	GameManager.update_lives.connect(_display_lives)
	GameManager.update_scores.connect(_display_score)
	GameManager.update_fish.connect(_display_fish)
	score_count.text = str(GameManager.total_score)

func _change_distance_units() -> void:
	use_imperial = GameManager.toggle_metric_or_imperial

func _display_speed(units : float) -> void:
	speed.text = "SPEED: "
	if use_imperial: 
		var imperial_units := metric_to_imperial_conversion * units
		speed.text += str("%.1f" % imperial_units) + " mph"
	else:
		speed.text += str("%.1f" % units) + " m/s"

func _display_floor(floor_num : int) -> void:
	floor_number.text = "FLOOR  " + str(floor_num + 1)

func _display_lives() -> void:
	for life in lives.get_children():
		life.queue_free()
	
	for i in GameManager.total_lives:
		var life_icon := cat_life.instantiate()
		lives.add_child(life_icon)

func _display_score() -> void:
	score_count.text = str(GameManager.total_score)

func _display_fish() -> void:
	fish_count.text = str(GameManager.total_fish) + "/100"
	if GameManager.total_fish == 100:
		GameManager.total_fish = 0
		AudioBus.extra_life.play()
		GameManager.total_lives += 1
		GameManager.update_lives.emit()
