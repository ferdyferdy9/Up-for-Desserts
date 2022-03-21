extends Node

const MIN_DB = -60
const MAX_DB = 0

var master_volume = 80 setget set_master
var music_volume = 80 setget set_music
var sound_volume = 100 setget set_sound


func _ready():
	self.master_volume = master_volume
	self.music_volume = music_volume
	self.sound_volume = sound_volume


func convertDB2Volume(input):
	return range_lerp(input, MIN_DB, MAX_DB, 0, 100)


func convertVolume2DB(input):
	return range_lerp(input, 0, 100, MIN_DB, MAX_DB)


func set_master(volume):
	volume = clamp(volume, 0, 100)
	
	master_volume = volume
	AudioServer.set_bus_volume_db(0, range_lerp(volume, 0, 100, MIN_DB, MAX_DB))


func set_music(volume):
	volume = clamp(volume, 0, 100)
	
	music_volume = volume
	AudioServer.set_bus_volume_db(1, range_lerp(volume, 0, 100, MIN_DB, MAX_DB))


func set_sound(volume):
	volume = clamp(volume, 0, 100)
	
	sound_volume = volume
	AudioServer.set_bus_volume_db(2, range_lerp(volume, 0, 100, MIN_DB, MAX_DB))
