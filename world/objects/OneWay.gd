extends KinematicBody2D

onready var area2d = $Area2D

func _process(delta: float) -> void:
	for b in area2d.get_overlapping_bodies():
		if "linear_velocity" in b:
			var plane = Vector2.RIGHT.rotated(rotation)
			if b.linear_velocity.normalized().dot(plane) > 0:
				b.global_position -= b.linear_velocity.project(plane) * delta
				b.linear_velocity = b.linear_velocity.project(Vector2.UP.rotated(rotation))
