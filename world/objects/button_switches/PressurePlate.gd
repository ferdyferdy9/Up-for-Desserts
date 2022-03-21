extends "res://world/objects/button_switches/Button.gd"

func _process(delta: float) -> void:
	_active = get_overlapping_bodies().size() > 0
	if _active != _last_active:
		if _active:
			activate()
		else:
			deactivate()
	_last_active = _active
