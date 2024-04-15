#@tool
extends Node2D

var Rope = preload("res://Assets/Rope.tscn")
@onready var start_node = $StartPoint
@onready var end_node = $EndPoint
var start_pos := Vector2.ZERO
var end_pos := Vector2.ZERO
@export var rope_collosion_height = Vector2(0,-12)

var temp_rope = null


func _ready() -> void:
	start_pos = start_node.global_position + rope_collosion_height
	end_pos = end_node.global_position + rope_collosion_height
	
	temp_rope = Rope.instantiate()
	add_sibling.call_deferred(temp_rope)
	#rope.get_stuff(start_pos, end_pos)
	#temp_rope.spawn_rope(start_pos, end_pos)




func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and !event.is_pressed():
		temp_rope.spawn_rope(start_pos, end_pos)
		#var rope = Rope.instantiate()
		#add_sibling(rope)
		#rope.spawn_rope(start_pos, end_pos)
		#start_pos = Vector2.ZERO
		#end_pos = Vector2.ZERO
