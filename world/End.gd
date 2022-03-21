extends Node


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		SoundManager.play_ui_accept()
		Transition.fade_out_with_pause()
		yield(Transition, "fade_out_finished")
		get_tree().change_scene("res://Title.tscn")
