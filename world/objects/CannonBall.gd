extends KinematicBody2D

var dir:Vector2 = Vector2.RIGHT

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(dir * delta)
	if collision:
		if collision.collider.is_in_group("Player"):
			get_tree().reload_current_scene()
		queue_free()
