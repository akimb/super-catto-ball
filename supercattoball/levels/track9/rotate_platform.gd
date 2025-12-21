extends AnimatableBody3D

@export var ccw : bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if ccw:
		animation_player.play("rotate_ccw")
	else:
		animation_player.play("rotate_cw")
