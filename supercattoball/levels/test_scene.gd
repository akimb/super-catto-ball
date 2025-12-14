extends Node3D

@onready var sample_music: AudioStreamPlayer = $"Sample Music"

func _ready() -> void:
	sample_music.play()
