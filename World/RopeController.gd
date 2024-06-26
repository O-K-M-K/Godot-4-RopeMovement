#@tool
extends Node2D

var Rope = preload("res://Assets/Rope.tscn")

@export var rope_collosion_height = Vector2(0,-12)
@onready var start_node = $StartPoint
@onready var end_node = $EndPoint

var start_pos := Vector2.ZERO
var end_pos := Vector2.ZERO

func _ready() -> void:
	start_pos = start_node.global_position + rope_collosion_height
	end_pos = end_node.global_position + rope_collosion_height
	
	var rope = Rope.instantiate()
	add_sibling.call_deferred(rope)
	await rope.ready
	rope.spawn_rope(start_pos, end_pos)

func _process(delta: float) -> void:
	wind()

func wind() -> void:
	var tween = create_tween()
	tween.tween_property($EndPoint, "position", Vector2.RIGHT * 1000, 1)
	#tween.tween_property($EndPoint, "position", Vector2.LEFT * 100, 1).as_relative()

