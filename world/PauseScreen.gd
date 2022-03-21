extends CanvasLayer

onready var container = $MarginContainer
onready var menu = $MarginContainer/Menu

var is_pause:bool

func _ready() -> void:
	container.hide()
	menu.is_active = false


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if !is_pause:
			pause()
		else:
			unpause()


func pause() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS
	SoundManager.play_ui_cancel()
	get_tree().paused = true
	is_pause = true
	container.show()
	menu.is_active = true


func unpause() -> void:
	pause_mode = Node.PAUSE_MODE_STOP
	SoundManager.play_ui_accept()
	is_pause = false
	container.hide()
	menu.is_active = false
	get_tree().call_deferred("set", "paused", false)


func _on_VBoxContainer_selected(idx) -> void:
	match(idx):
		0:
			unpause()
		1:
			pause_mode = Node.PAUSE_MODE_STOP
			SoundManager.play_ui_accept()
			Transition.fade_out_with_pause()
			yield(Transition, "fade_out_finished")
			get_tree().reload_current_scene()
		2:
			pause_mode = Node.PAUSE_MODE_STOP
			SoundManager.play_ui_accept()
			Transition.fade_out_with_pause()
			yield(Transition, "fade_out_finished")
			get_tree().change_scene("res://Title.tscn")
