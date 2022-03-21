extends Area2D

export(bool) var is_active:bool
export(Vector2) var wind_dir:Vector2 = Vector2(0, -1)
export(float) var wind_strength:float = 100
export(float) var max_speed:float = 600

onready var particles = $Particles2D

func _physics_process(delta: float) -> void:
	if is_active:
		particles.emitting = true
		for b in get_overlapping_bodies():
			if b.is_in_group("Rock"):
				continue
			if "linear_velocity" in b:
				b.linear_velocity += wind_dir * wind_strength * 60 * delta
				
				var projection:Vector2 = b.linear_velocity.project(wind_dir)
				if projection.dot(wind_dir) > 0:
					var diff:float = max_speed - projection.length() 
					if diff < 0:
						b.linear_velocity += wind_dir * diff
	else:
		particles.emitting = false


func activate():
	is_active = true


func deactivate():
	is_active = false
