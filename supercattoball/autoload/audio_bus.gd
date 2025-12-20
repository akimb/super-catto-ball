extends Node

## MUSIC
@onready var main_menu_theme: AudioStreamPlayer = $"Music/Main Menu Theme"

## SFX
@onready var meow: AudioStreamPlayer = $SFX/Meow
@onready var confirm: AudioStreamPlayer = $SFX/Confirm
@onready var button_hover: AudioStreamPlayer = $"SFX/Button Hover"
@onready var startup: AudioStreamPlayer = $SFX/Startup
@onready var whoosh: AudioStreamPlayer = $SFX/Whoosh
@onready var fish: AudioStreamPlayer = $"SFX/Fish!"
@onready var extra_life: AudioStreamPlayer = $"SFX/Extra Life"
