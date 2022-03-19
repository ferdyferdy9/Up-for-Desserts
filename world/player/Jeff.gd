extends "res://world/player/Player.gd"

onready var grapple = $Grapple


func _process(delta: float) -> void:
	if is_controlled:
		if Input.is_action_just_pressed("attack"):
			grapple.shoot()


func apply_input(desired, delta) -> void:
	if grapple.is_swing:
		linear_velocity.x += sign(desired) * move_accel * 30 * delta
	else:
		.apply_input(desired, delta)
