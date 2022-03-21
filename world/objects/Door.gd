extends Area2D

export(PackedScene) var next_level:PackedScene


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		if player_count() > 2:
			SoundManager.play_door()
			get_tree().change_scene_to(next_level)


func player_count() -> int:
	var c = 0
	for b in get_overlapping_bodies():
		if b.is_in_group("Player"):
			c+=1
	return c
