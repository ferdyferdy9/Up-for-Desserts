extends KinematicBody2D

export(float) var swing_length:float = 128

var player:Node2D

func _process(delta: float) -> void:
	if !player:
		return
	
	var dist = player.global_position.distance_to(global_position)
	if dist > swing_length:
		var normal = player.global_position.direction_to(global_position)
		player.global_position = player.global_position.move_toward(global_position - normal * swing_length, dist * 5 * delta)
		player.linear_velocity = player.linear_velocity.slide(normal)

