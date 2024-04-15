extends Node2D

## Switching between fullscreen and not fullscreen by pressing esc

var Rope = preload("res://Assets/Rope.tscn")
var start_pos := Vector2.ZERO
var end_pos := Vector2.ZERO

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		swap_fullscreen_mode()

func swap_fullscreen_mode():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


	
