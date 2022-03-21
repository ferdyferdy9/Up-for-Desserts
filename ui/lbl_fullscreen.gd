extends Label

func _process(delta: float) -> void:
	if visible:
		if OS.window_fullscreen:
			text = "Fullscreen : On"
		else:
			text = "Fullscreen : Off"
