extends "res://world/player/Player.gd"

onready var grapple = $Grapple
onready var _ed = get_tree().get_nodes_in_group("Ed")[0]


func _process(delta: float) -> void:	
	if is_controlled:
		if Input.is_action_just_pressed("attack"):
			grapple.shoot()
		
		if Input.is_action_just_pressed("jump"):
			if _ed.grabbed_body == self:
				_ed.grabbed_body = null
				_ed.remove_collision_exception_with(self)
				is_override_facing = false
				is_override_animation = false
				set_physics_process(true)
				jump()


func apply_input(desired, delta) -> void:
	if grapple.is_swing:
		linear_velocity.x += sign(desired) * move_accel * 30 * delta
	else:
		.apply_input(desired, delta)
