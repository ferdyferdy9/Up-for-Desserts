extends KinematicBody2D

var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")
var linear_velocity:Vector2


func _physics_process(delta: float) -> void:
	update_physics_platformer(delta)


func update_physics_platformer(delta:float) -> void:
	var collision =	move_and_collide(linear_velocity * delta)
	
	if collision and collision.normal.dot(Vector2.UP) > 0.5:
		linear_velocity.y = 0
	else:
		linear_velocity.y += gravity * 2 * delta
