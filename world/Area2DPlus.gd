class_name Area2DPlus
extends Area2D


func is_colliding() -> bool:
	for b in get_overlapping_areas():
		if (b.collision_layer & collision_mask) != 0:
			return true
	
	return false
