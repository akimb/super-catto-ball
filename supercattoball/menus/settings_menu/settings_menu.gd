extends Control

@onready var metric_2_imperial: GenericButton = $"Speed Units/HBoxContainer/Metric2Imperial"


func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		#GameManager.toggle_metric_or_imperial = true
		GameManager.distance_unit_toggle.emit(true)
		metric_2_imperial.text = "Imperial"
	else:
		#GameManager.toggle_metric_or_imperial = false
		GameManager.distance_unit_toggle.emit(false)
		metric_2_imperial.text = "Metric"
	
	
