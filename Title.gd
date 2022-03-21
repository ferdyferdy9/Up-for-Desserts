extends Node

export(PackedScene) var start_scene:PackedScene

onready var navigator = $Navigator
onready var title_menu = $Navigator/Title/Menu
onready var options_menu = $Navigator/Options/Menu

func _process(delta: float) -> void:
	if navigator.index == 2:
		if Input.is_action_just_pressed("ui_accept"):
			navigator.index = 0
			title_menu.call_deferred("set", "is_active", true)
			title_menu.index = 2
			options_menu.is_active = false
			SoundManager.play_ui_cancel()


func _on_Title_Menu_selected(idx) -> void:
	match(idx):
		0: # Start
			get_tree().change_scene_to(start_scene)
			SoundManager.play_ui_accept()
		1: # Options
			navigator.index = 1
			title_menu.is_active = false
			options_menu.is_active = true
			options_menu.index = 0
			SoundManager.play_ui_accept()
		2: # Credits
			navigator.index = 2
			title_menu.is_active = false
			options_menu.is_active = false
			SoundManager.play_ui_accept()
		3: # Exit
			get_tree().quit()
			SoundManager.play_ui_cancel()


func _on_Options_Menu_selected(idx) -> void:
	match(idx):
		3: # Fullscreen
			OS.window_fullscreen = !OS.window_fullscreen
		4: # Back
			navigator.index = 0
			title_menu.call_deferred("set", "is_active", true)
			title_menu.index = 1
			options_menu.is_active = false
			SoundManager.play_ui_cancel()
