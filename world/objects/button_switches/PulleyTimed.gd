extends "res://world/objects/button_switches/Pulley.gd"

export(float) var wait_time:float = 3

onready var timer = $Timer
onready var label = $Label

var is_hold = false

func _ready() -> void:
	label.hide()
	timer.wait_time = wait_time
	
	if start_active:
		set_switch(true)
	else:
		set_switch(false)


func _process(delta: float) -> void:
	if is_hold:
		timer.start()
	
	if timer.time_left > 0:
		label.text = str(int(timer.time_left*10)/10.0)
		label.show()
	else:
		label.hide()


func activate() -> void:
	if sprite.frame != 1:
		$AudioStreamPlayer.play()
	sprite.frame = 1
	label.text = str(timer.wait_time)
	label.show()
	is_hold = true
	timer.start()
	if start_active:
		set_switch(false)
	else:
		set_switch(true)


func deactivate() -> void:
	sprite.frame = 0
	is_hold = false
	if timer:
		timer.start()


func _on_Timer_timeout() -> void:
	if start_active:
		set_switch(true)
	else:
		set_switch(false)

