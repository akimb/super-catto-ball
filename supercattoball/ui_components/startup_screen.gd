extends Control

@onready var logo: AnimatedSprite2D = $Splash/Logo
@onready var logo_pos: Marker2D = $"Splash/Logo Pos"
@onready var label: Label = $Splash/Label

@onready var splash: Control = $Splash

const label_color : Color = Color("cdcdcd")
const transparent : Color = Color("ffffff00")
const MAIN_MENU : PackedScene = preload("uid://dde6piw0cky7b")

func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	var logo_in := get_tree().create_tween()
	logo_in.tween_property(logo, "position", logo_pos.position, 0.5).set_trans(Tween.TRANS_CUBIC)
	AudioBus.whoosh.play()
	await logo_in.finished
	var label_in := get_tree().create_tween()
	label_in.tween_property(label, "label_settings:font_color", label_color, 0.5)
	AudioBus.startup.play()
	await label_in.finished
	
	await get_tree().create_timer(2.0).timeout
	var fade_splash := get_tree().create_tween()
	fade_splash.tween_property(splash, "modulate", transparent, 1.0)
	await fade_splash.finished
	logo_in.kill()
	label_in.kill()
	fade_splash.kill()
	
	get_tree().change_scene_to_packed(MAIN_MENU)
