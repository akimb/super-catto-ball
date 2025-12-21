extends Control

@onready var timer_display: RichTextLabel = $"Timer Display"

func _ready() -> void:
	GameManager.update_timer.connect(_display_time)

func _display_time(time_left : float) -> void:
	timer_display.text = str("%.2f" % time_left)
