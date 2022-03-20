extends Area2D

export(bool) var is_active:bool
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
				b.linear_velocity.y -= wind_strength * 60 * delta
				b.linear_velocity.y = max(b.linear_velocity.y, -max_speed)
	else:
		particles.emitting = false


func activate():
	is_active = true


func deactivate():
	is_active = false
