extends Node2D

export(float) var max_arrow_dist = 500
export(float) var pull_time = 0.2

onready var arrow = $Arrow
onready var tween = $Tween
onready var shot_delay_timer = $ShotDelayTimer

var has_shot:bool
var gonna_shoot:bool
var is_swing:bool
var is_switch:bool
var _swing_target:Node2D
var _switch_target:Node2D
var is_shot_up:bool = false

onready var _ed = get_tree().get_nodes_in_group("Ed")[0]
onready var parent = get_parent()


func _ready() -> void:
	reset()


func _process(delta: float) -> void:
	if _ed.grabbed_body == parent:
		parent.is_override_animation = true
		if parent.anim_player.current_animation in ["walk", "jump", "fall"]:
			parent.anim_player.play("idle")
	
	if is_swing:
		parent.is_override_animation = true
		parent.anim_player.play("swing")
	
	if is_swing or tween.is_active():
		if _ed.grabbed_body == parent:
			_ed.global_position = parent.global_position - _ed.hold_offset
			_ed.linear_velocity = Vector2.ZERO
			parent.set_physics_process(true)
	
	if is_switch:
		arrow.global_position = _switch_target.global_position
		parent.anim_player.play("side_pulled")
		parent.is_override_facing = true
		parent.facing_dir.x = sign(_switch_target.global_position.x - parent.global_position.x)
		var is_btn_jump:bool = Input.is_action_just_pressed("attack")
		if get_parent().is_controlled and is_btn_jump:
			_switch_target.deactivate()
			_switch_target = null
			reset()
	
	if is_swing:
		arrow.global_position = _swing_target.global_position
		var is_btn_jump:bool = Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("attack")
		if get_parent().is_controlled and is_btn_jump:
			get_parent().jump()
			_swing_target.player = null
			reset()
	elif has_shot:
		if arrow.position.length() > max_arrow_dist:
			if is_switch:
				_switch_target.deactivate()
				_switch_target = null
			reset()


func shoot():
	if has_shot or gonna_shoot:
		return
	
	var dir:Vector2 = get_parent().facing_dir
	if dir.y > 0:
		dir.y = 0
	if dir.y != 0:
		dir.x = 0
	$ArrowSFX.play()
	
	gonna_shoot = true
	if dir.y < 0:
		parent.anim_player.play("shoot_up")
	else:
		parent.anim_player.play("shoot_side")
	parent.is_override_animation = true
	parent.is_override_facing = true
	
	shot_delay_timer.start()
	yield(shot_delay_timer, "timeout")
	gonna_shoot = false
	show()
	arrow.is_active = true
	arrow.dir = dir
	arrow.rotation = atan2(dir.y, dir.x)
	has_shot = true
	if dir.y < 0:
		is_shot_up = true


func reset():
	hide()
	arrow.position = Vector2.ZERO
	arrow.dir = Vector2.ZERO
	arrow.is_active = false
	has_shot = false
	is_swing = false
	is_switch = false
	parent.is_override_animation = false
	parent.is_override_facing = false
	is_shot_up = false


func _on_Arrow_hit_something(body:Node) -> void:
	if is_switch or is_swing or not has_shot or tween.is_active():
		return
	
	if body == _ed.grabbed_body:
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
	elif body.is_in_group("Switch"):
		arrow.dir = Vector2.ZERO
		arrow.is_active = false
		body.activate()
		_switch_target = body
		is_switch = true
	else:
		reset()


func pull_player() -> void:
	if arrow.dir.y == 0:
		parent.is_override_animation = true
		parent.anim_player.play("side_pulled")
	
	arrow.dir = Vector2.ZERO
	arrow.is_active = false
	
	$PulledSFX.play()
	
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
	if arrow.dir.y == 0:
		parent.is_override_animation = true
		parent.anim_player.play("side_pulled")
	
	$PulledSFX.play()
	arrow.dir = Vector2.ZERO
	arrow.is_active = false
	
	var parent = get_parent()
	var offset = 48 * (parent.global_position - body.global_position).normalized()
	tween.interpolate_property(
		body, "global_position",
		body.global_position, parent.global_position - offset, pull_time
	)
	var arrow_offset = (parent.global_position - offset) - body.global_position 
	tween.interpolate_property(
		arrow, "global_position",
		arrow.global_position, arrow.global_position + arrow_offset, pull_time
	)
	tween.start()


func _on_Tween_tween_all_completed() -> void:
	var parent = get_parent()
	if is_shot_up:
		parent.linear_velocity.x = 0
		parent.linear_velocity.y = -parent.jump_strength * 0.63
	else:
		parent.linear_velocity = Vector2.ZERO
	reset()
