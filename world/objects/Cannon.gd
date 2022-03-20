extends KinematicBody2D

export(float) var firing_rate:float = 1
export(Vector2) var dir:Vector2 = Vector2(-1, 0)
export(float) var speed:float = 600

onready var timer = $Timer

var cannonball_scene = preload("res://world/objects/CannonBall.tscn")


func _ready() -> void:
	timer.wait_time = 1.0/firing_rate
	timer.start()


func _on_Timer_timeout() -> void:
	var cannonball = cannonball_scene.instance()
	cannonball.add_collision_exception_with(self)
	cannonball.dir = dir * speed
	cannonball.global_position = global_position
	get_parent().add_child(cannonball)
