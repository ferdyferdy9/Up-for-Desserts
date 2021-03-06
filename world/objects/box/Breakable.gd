extends StaticBody2D

var particle_scene = preload("res://world/objects/_internal/BreakParticle.tscn")

func destroy() -> void:
	var particle = particle_scene.instance()
	particle.global_position = global_position
	get_parent().add_child(particle)
	SoundManager.play_obj_break()
	queue_free()
