extends Control

@onready var metric_2_imperial: GenericButton = $"Speed Units/VBoxContainer/Unit Conversion/Metric2Imperial"
@onready var sfx_volume_slider: HSlider = $"Speed Units/VBoxContainer/SFX/SFX Volume Slider"
@onready var music_volume_slider: HSlider = $"Speed Units/VBoxContainer/Music/Music Volume Slider"

var use_imperial := false
var music_idx := AudioServer.get_bus_index("Music")
var sfx_idx := AudioServer.get_bus_index("SFX")

func _ready() -> void:
	AudioServer.set_bus_volume_db(sfx_idx, linear_to_db(sfx_volume_slider.value))
	AudioServer.set_bus_volume_db(music_idx, linear_to_db(music_volume_slider.value))
	
func _on_metric_2_imperial_toggled(toggled_on: bool) -> void:
	if toggled_on:
		GameManager.toggle_metric_or_imperial = true
		#GameManager.distance_unit_toggle.emit(true)
		metric_2_imperial.text = "Imperial"
	else:
		GameManager.toggle_metric_or_imperial = false
		#GameManager.distance_unit_toggle.emit(false)
		metric_2_imperial.text = "Metric"
	#print(GameManager.toggle_metric_or_imperial)

func _on_sfx_volume_slider_value_changed(value: float) -> void:
	GameManager.sfx_db = sfx_volume_slider.value
	AudioServer.set_bus_volume_db(sfx_idx, linear_to_db(sfx_volume_slider.value))

func _on_music_volume_slider_value_changed(value: float) -> void:
	GameManager.music_db = music_volume_slider.value
	AudioServer.set_bus_volume_db(music_idx, linear_to_db(music_volume_slider.value))

func _on_save_pressed() -> void:
	pass # Replace with function body.


func _on_settings_back_pressed() -> void:
	hide()
