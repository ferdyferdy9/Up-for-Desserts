tool
extends KinematicBody2D

export(bool) var is_active:bool = false
export(Vector2) var move_direction:Vector2 = Vector2(0, -128) setget set_move_direciton
export(float) var speed:float = 360

onready var raycast = $RayCast2D

var pos_a:Vector2
var pos_b:Vector2


func _ready() -> void:
	self.move_direction = move_direction
	pos_a = global_position
	pos_b = global_position + move_direction.rotated(rotation)


func _physics_process(delta: float) -> void:
	if Engine.editor_hint:
		return
	
	if is_active:
		global_position = global_position.move_toward(pos_b, speed * delta)
	else:
		global_position = global_position.move_toward(pos_a, speed * delta)


func set_move_direciton(new_dir):
	move_direction = new_dir
	
	if raycast:
		raycast.cast_to = move_direction * 0.25


func activate():
	is_active = true


func deactivate():
	is_active = false
