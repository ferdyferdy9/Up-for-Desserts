extends KinematicBody2D

var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")
var linear_velocity:Vector2

func _physics_process(delta: float) -> void:
	update_physics_platformer(delta)


func update_physics_platformer(delta:float) -> void:
	linear_velocity.x = 0
	if is_on_floor():
		linear_velocity.y = 0
	else:
		linear_velocity.y += gravity * delta
	
	var last_pos = position
	linear_velocity = move_and_slide_with_snap(linear_velocity, Vector2.DOWN * 2, Vector2.UP)
	position.x -= get_floor_velocity().x * delta
	if is_on_floor() and not is_on_wall():
		position.x = last_pos.x
