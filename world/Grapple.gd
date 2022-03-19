extends Node2D

export(float) var max_arrow_dist = 500
export(float) var pull_time = 0.2

onready var arrow = $Arrow
onready var tween = $Tween

var has_shot:bool
var is_swing:bool
var _swing_target:Node2D


func _ready() -> void:
	reset()


func _process(delta: float) -> void:
	if has_shot:
		if arrow.position.length() > max_arrow_dist:
			reset()
	if is_swing:
		arrow.global_position = _swing_target.global_position
		if get_parent().is_controlled and Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("attack"):
			get_parent().jump()
			_swing_target.player = null
			reset()


func shoot():
	if has_shot:
		return
	
	show()
	var dir:Vector2 = get_parent().facing_dir
	if dir.y != 0:
		dir.x = 0
	arrow.is_active = true
	arrow.dir = dir
	arrow.rotation = atan2(dir.y, dir.x)
	has_shot = true


func reset():
	hide()
	arrow.position = Vector2.ZERO
	arrow.dir = Vector2.ZERO
	arrow.is_active = false
	has_shot = false
	is_swing = false


func _on_Arrow_hit_something(body:Node) -> void:
	if not has_shot:
		return
	elif tween.is_active():
		return
	
	if body.is_in_group("Target"):
		pull_player()
	elif body.is_in_group("Movable"):
		if arrow.dir.y != 0:
			pull_player()
		else:
			pull_obj(body)
	elif body.is_in_group("Swing"):
		arrow.dir = Vector2.ZERO
		arrow.is_active = false
		body.player = get_parent()
		_swing_target = body
		is_swing = true
	else:
		reset()


func pull_player() -> void:
	arrow.dir = Vector2.ZERO
	arrow.is_active = false
	
	var parent = get_parent()
	tween.interpolate_property(
		parent, "global_position",
		parent.global_position, arrow.global_position, pull_time
	)
	tween.interpolate_property(
		arrow, "global_position",
		arrow.global_position, arrow.global_position, pull_time
	)
	tween.start()


func pull_obj(body:Node2D) -> void:
	arrow.dir = Vector2.ZERO
	arrow.is_active = false
	
	var parent = get_parent()
	var offset = 48 * (parent.global_position - body.global_position).normalized()
	tween.interpolate_property(
		body, "global_position",
		body.global_position, parent.global_position - offset, pull_time
	)
	tween.interpolate_property(
		arrow, "global_position",
		arrow.global_position, parent.global_position - offset, pull_time
	)
	tween.start()


func _on_Tween_tween_all_completed() -> void:
	reset()
	var parent = get_parent()
	parent.linear_velocity = Vector2.ZERO
