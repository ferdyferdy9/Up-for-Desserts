extends KinematicBody2D

export(float) var firing_rate:float = 0.25
export(Vector2) var dir:Vector2 = Vector2(-1, 0)
export(float) var speed:float = 300
export(bool) var is_up:bool = false

onready var timer = $Timer
onready var anim_player = $AnimationPlayer

var poof_scene = preload("res://world/objects/Poof.tscn")
var cannonball_scene = preload("res://world/objects/CannonBall.tscn")


func _ready() -> void:
	timer.wait_time = 1.0/firing_rate
	timer.start()


func _on_Timer_timeout() -> void:
	if is_up:
		anim_player.play("shoot_up")
	else:
		anim_player.play("shoot")
	$AudioStreamPlayer.play()


func shoot() -> void:
	var cannonball = cannonball_scene.instance()
	cannonball.add_collision_exception_with(self)
	cannonball.dir = dir * speed
	cannonball.global_position = global_position
	get_parent().add_child(cannonball)
	
	var poof = poof_scene.instance()
	if is_up:
		$Position2D.add_child(poof)
	else:
		$Position2D2.add_child(poof)



func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if is_up:
		anim_player.play("idle_up")
	else:
		anim_player.play("idle")
