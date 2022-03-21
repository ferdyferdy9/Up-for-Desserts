extends Node

const ui_accept_sfx = preload("res://assets/sfx/uiyes.wav")
const ui_cancel_sfx = preload("res://assets/sfx/uicancel.wav")
const take_damage_sfx = preload("res://assets/sfx/take damage.ogg")
const obj_break_sfx = preload("res://assets/sfx/objects break.ogg")
const door_sfx = preload("res://assets/sfx/door.ogg")
const grab_sfx = preload("res://assets/sfx/grab.wav")
const throw_sfx = preload("res://assets/sfx/throw.wav")
const jump_sfx = preload("res://assets/sfx/jump.ogg")


func play_throw() -> void:
	play_audio(throw_sfx)


func play_jump() -> void:
	play_audio(jump_sfx)


func play_ui_accept() -> void:
	play_audio(ui_accept_sfx)


func play_ui_cancel() -> void:
	play_audio(ui_cancel_sfx)


func play_grab() -> void:
	play_audio(grab_sfx)


func play_door() -> void:
	play_audio(door_sfx)


func play_obj_break() -> void:
	play_audio(obj_break_sfx)


func play_take_damage() -> void:
	play_audio(take_damage_sfx)


func play_audio(stream):
	var audio_player := AudioStreamPlayer.new()
	audio_player.connect("finished", audio_player, "queue_free")
	audio_player.stream = stream
	audio_player.autoplay = true
	audio_player.bus = "SFX"
	add_child(audio_player)
	audio_player.play()
	
