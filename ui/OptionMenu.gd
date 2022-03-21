extends "res://ui/Menu.gd"

onready var master_progress = $GridContainer/master_progress
onready var music_progress = $GridContainer/music_progress
onready var sfx_progress = $GridContainer/sfx_progress

const volume_rate = 5


func _ready() -> void:
	master_progress.value = AudioManager.master_volume
	music_progress.value = AudioManager.music_volume
	sfx_progress.value = AudioManager.sound_volume


func _process(delta: float) -> void:
	if is_active:
		if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
			match(index):
				0:
					update_progress(master_progress)
					AudioManager.master_volume = master_progress.value
				1:
					update_progress(music_progress)
					AudioManager.music_volume = music_progress.value
				2:
					update_progress(sfx_progress)
					AudioManager.sound_volume = sfx_progress.value


func update_progress(progress):
	if Input.is_action_just_pressed("ui_left"):
		progress.value -= volume_rate
	if Input.is_action_just_pressed("ui_right"):
		progress.value += volume_rate
