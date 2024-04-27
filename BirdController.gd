@tool
extends CharacterBody2D


@onready var sprite = $Sprite
@onready var anim = $AnimationPlayer
@export var flipped := false

var flying := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.frame = 0
	sprite.set_flip_h(flipped)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if not is_on_floor() and not flying:
			velocity.y = 10
		move_and_slide()



##-1 is left 1 is right
func fly_away(dir: int):
	flying = true
	var dir_b = false
	if dir == -1: dir_b = true 
	sprite.set_flip_h(dir_b)
	anim.play("Flapping")
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(1000*dir,-1000), 20)




func _on_area_r_body_entered(body: Player) -> void:
	if not flying:
		fly_away(-1)


func _on_area_l_body_entered(body: Player) -> void:
	if not flying:
		fly_away(1)
