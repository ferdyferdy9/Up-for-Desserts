tool
extends KinematicBody2D

export(bool) var is_active:bool = true
export(Vector2) var move_direction:Vector2 = Vector2(0, -256) setget set_move_direciton
export(float) var speed:float = 120

onready var raycast = $RayCast2D

var has_reach:bool
var pos_a:Vector2
var pos_b:Vector2


func _ready() -> void:
	self.move_direction = move_direction
	pos_a = global_position
	pos_b = global_position + move_direction.rotated(rotation)


func _physics_process(delta: float) -> void:
	if Engine.editor_hint:
		return
	
	if not is_active:
		return
	
	if not has_reach:
		global_position = global_position.move_toward(pos_b, speed * delta)
		if global_position.distance_squared_to(pos_b) < 1:
			has_reach = true
	else:
		global_position = global_position.move_toward(pos_a, speed * delta)
		if global_position.distance_squared_to(pos_a) < 1:
			has_reach = false


func set_move_direciton(new_dir):
	move_direction = new_dir
	
	if raycast:
		raycast.cast_to = move_direction * 0.25


func activate():
	is_active = true


func deactivate():
	is_active = false
