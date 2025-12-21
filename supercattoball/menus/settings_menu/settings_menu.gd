extends Control

@onready var metric_2_imperial: GenericButton = $"Speed Units/VBoxContainer/Unit Conversion/Metric2Imperial"
@onready var sfx_volume_slider: HSlider = $"Speed Units/VBoxContainer/SFX/SFX Volume Slider"
@onready var music_volume_slider: HSlider = $"Speed Units/VBoxContainer/Music/Music Volume Slider"
@onready var mouse_sensitivity_slider: HSlider = $"Speed Units/VBoxContainer/Mouse Sensitivity/Mouse Sensitivity Slider"
@onready var mouse_sensitivity_text: Label = $"Speed Units/VBoxContainer/Mouse Sensitivity/Mouse Sensitivity Slider/Mouse Sensitivity Text"
@onready var sfx_volume_text: Label = $"Speed Units/VBoxContainer/SFX/SFX Volume Slider/SFX Volume Text"
@onready var music_volume_text: Label = $"Speed Units/VBoxContainer/Music/Music Volume Slider/Music Volume Text"

var use_imperial := false
var music_idx := AudioServer.get_bus_index("Music")
var sfx_idx := AudioServer.get_bus_index("SFX")

func _ready() -> void:
	initialize_sliders()

func _on_metric_2_imperial_toggled(toggled_on: bool) -> void:
	if toggled_on:
		GameManager.toggle_metric_or_imperial = true
		metric_2_imperial.text = "Imperial"
	else:
		GameManager.toggle_metric_or_imperial = false
		metric_2_imperial.text = "Metric"

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


func _on_mouse_sensitivity_slider_value_changed(value: float) -> void:
	var val_converted : float = value
	mouse_sensitivity_text.text = str(value)
	GameManager.mouse_sensitivity = val_converted / 100.0

func initialize_sliders() -> void:
	mouse_sensitivity_slider.value = GameManager.mouse_sensitivity * 100
	mouse_sensitivity_text.text = str(GameManager.mouse_sensitivity * 100)
	
	sfx_volume_text.text = str(sfx_volume_slider.value)
	AudioServer.set_bus_volume_db(sfx_idx, linear_to_db(sfx_volume_slider.value))
	music_volume_text.text = str(music_volume_slider.value)
	AudioServer.set_bus_volume_db(music_idx, linear_to_db(music_volume_slider.value))
