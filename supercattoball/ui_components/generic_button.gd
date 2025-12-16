extends Button

func _on_pressed() -> void:
	AudioBus.confirm.play()

func _on_mouse_entered() -> void:
	AudioBus.meow.play()
