#@tool
extends Node2D

var RopePiece = preload("res://Assets/RopePiece.tscn")
var piece_length := 12.0
var rope_parts := []
var rope_parts_dict := {}
var rope_close_tolerance := 0.0
var rope_points : PackedVector2Array = []
var rope_colors: PackedColorArray = []

var active_rope_id := -1 : set = set_active_rope_dict_id

var color1 := Color("#0f1e2b")

@export var deafult_mass : float = 1.0
var player_applied_force : float

@onready var rope_start_piece = $RopeStartPiece2
@onready var rope_end_piece = $RopeEndPiece2
@onready var rope_start_joint = $RopeStartPiece2/C/J
@onready var rope_end_joint = $RopeEndPiece2/C/J


func set_active_rope_id(value:int):
	
	#i need to make it more efficient - hash table maybe? gotta be better than a list...
	if active_rope_id != value:
		active_rope_id = value
		if active_rope_id == -1:
			for i in rope_parts:
				(i as RigidBody2D).mass = deafult_mass
				(i as RigidBody2D).gravity_scale = 0.2
		else:
			(rope_parts[active_rope_id] as RigidBody2D).mass = player_applied_force
			#(rope_parts[active_rope_id] as RigidBody2D).gravity_scale = -0.2
			
			for i in len(rope_parts):
				if i == active_rope_id:
					(rope_parts[i] as RigidBody2D).mass = player_applied_force
				else:
					(rope_parts[i] as RigidBody2D).mass = deafult_mass

func set_active_rope_dict_id(value: int):
	print("setting mass")
	if active_rope_id != value:
		active_rope_id = value
		if active_rope_id == -1:
			for i in rope_parts_dict.values():
				(i as RigidBody2D).mass = deafult_mass
				(rope_parts[active_rope_id] as RigidBody2D).gravity_scale = 0.2
		else:
			(rope_parts_dict[str(active_rope_id)] as RigidBody2D).mass = player_applied_force 
			
			for i in rope_parts_dict.keys():
				if i != str(active_rope_id):
					(rope_parts_dict[i] as RigidBody2D).gravity_scale = 0.2
					var temp_mass = (rope_parts_dict[i] as RigidBody2D).mass
					if temp_mass != deafult_mass:
						temp_mass = deafult_mass

func _ready():
	rope_start_piece.set_freeze_enabled(true)
	rope_end_piece.set_freeze_enabled(true)
	

var current_depth := 0.0
var max_depth := 0.0
var reached_max_depth := false
func has_reached_max_depth():
	if active_rope_id != -1:
		current_depth = (rope_parts_dict[str(active_rope_id)] as RigidBody2D).global_position.y
		
		if current_depth > max_depth:
			max_depth = current_depth
		elif current_depth < max_depth:
			reached_max_depth = true
	else:
		reached_max_depth = false
		current_depth = 0.0
		max_depth = 0.0
	

func reset_masses():
	if active_rope_id != -1 and (rope_parts_dict[str(active_rope_id)] as RigidBody2D).gravity_scale > 0:
		#print("removing gravity")
		(rope_parts_dict[str(active_rope_id)] as RigidBody2D).gravity_scale -= 0.01
	elif active_rope_id != -1:
		pass
		#print("adding gravity")
		#(rope_parts_dict[str(active_rope_id)] as RigidBody2D).gravity_scale += 0.01
		

func _process(delta: float) -> void:
	has_reached_max_depth()
	reset_masses()
	get_rope_points()
	if !rope_points.is_empty():
		queue_redraw()

func spawn_rope(start_pos:Vector2, end_pos:Vector2):
	print("Spawn rope called")
	rope_start_piece.global_position = start_pos
	rope_end_piece.global_position = end_pos
	start_pos = rope_start_joint.global_position
	end_pos = rope_end_joint.global_position
	
	var distance = start_pos.distance_to(end_pos)
	var pieces_ammount = round(distance/piece_length)
	var spawn_angle = (end_pos-start_pos).angle() - PI/2
	
	create_rope(pieces_ammount, rope_start_piece, end_pos, spawn_angle)
	


func create_rope(pieces_amount:int, parent:Object, end_pos:Vector2, spawn_angle:float) -> void:
	rope_colors.append(color1)
	for i in pieces_amount:
		parent = add_piece(parent, i, spawn_angle)
		parent.set_name("rope_piece_"+str(i))
		rope_parts.append(parent)
		rope_parts_dict[str(i)] = parent
		
		var joint_pos = parent.get_node("C/J").global_position
		if joint_pos.distance_to(end_pos) < rope_close_tolerance:
			break
	
	rope_end_joint.node_a = rope_end_piece.get_path()
	rope_end_joint.node_b = rope_parts[-1].get_path()
	

func add_piece(parent:Object, id:int, spawn_angle:float) -> RopePiece:
	var joint : PinJoint2D = parent.get_node("C/J") as PinJoint2D
	var piece : RopePiece = RopePiece.instantiate() as RopePiece
	piece.global_position = joint.global_position
	piece.rotation = spawn_angle
	piece.parent = self
	piece.id = id
	add_child(piece)
	joint.node_a = parent.get_path()
	joint.node_b = piece.get_path()
	
	return piece
	
func get_rope_points() -> void:
	rope_points = []
	rope_points.append(rope_start_joint.global_position)
	for r in rope_parts:
		rope_points.append(r.global_position)
	rope_points.append(rope_end_joint.global_position)
	


func _draw():
	draw_polyline_colors(rope_points, rope_colors, 1.0)
