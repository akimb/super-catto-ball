extends Node

## MUSIC
@onready var game_theme: AudioStreamPlayer = $"Music/Game Theme"
@onready var main_menu_theme: AudioStreamPlayer = $"Music/Main Menu Theme"

## SFX
@onready var meow: AudioStreamPlayer = $SFX/Meow
@onready var confirm: AudioStreamPlayer = $SFX/Confirm
@onready var button_hover: AudioStreamPlayer = $"SFX/Button Hover"
@onready var startup: AudioStreamPlayer = $SFX/Startup
@onready var whoosh: AudioStreamPlayer = $SFX/Whoosh
@onready var fish: AudioStreamPlayer = $"SFX/Fish!"
@onready var extra_life: AudioStreamPlayer = $"SFX/Extra Life"
@onready var howl: AudioStreamPlayer = $SFX/Howl
@onready var countdown_1: AudioStreamPlayer = $"SFX/1"
@onready var countdown_2: AudioStreamPlayer = $"SFX/2"
@onready var countdown_3: AudioStreamPlayer = $"SFX/3"
@onready var countdown_4: AudioStreamPlayer = $"SFX/4"
@onready var countdown_5: AudioStreamPlayer = $"SFX/5"
@onready var countdown_6: AudioStreamPlayer = $"SFX/6"
@onready var countdown_7: AudioStreamPlayer = $"SFX/7"
@onready var countdown_8: AudioStreamPlayer = $"SFX/8"
@onready var countdown_9: AudioStreamPlayer = $"SFX/9"
@onready var countdown_10: AudioStreamPlayer = $"SFX/10"
@onready var game_ready: AudioStreamPlayer = $SFX/Ready
@onready var go: AudioStreamPlayer = $SFX/Go
@onready var goal: AudioStreamPlayer = $SFX/Goal
@onready var game_continue: AudioStreamPlayer = $SFX/Continue
@onready var super_catto_ball: AudioStreamPlayer = $"SFX/Super Catto Ball"
@onready var bonus: AudioStreamPlayer = $SFX/Bonus
@onready var applause: AudioStreamPlayer = $SFX/Applause
@onready var move: AudioStreamPlayer = $SFX/Move
@onready var wind: AudioStreamPlayer = $SFX/Wind
