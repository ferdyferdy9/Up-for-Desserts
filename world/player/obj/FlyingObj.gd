extends KinematicBody2D

signal be_destroyed(attached_obj)

export(float) var speed:float = 600

onready var platform_detection = $PlatformDetection

var attached_obj:Node2D
var dir:Vector2 = Vector2.RIGHT

func _process(delta: float) -> void:
	if attached_obj and attached_obj.is_in_group("Player"):
		attached_obj.is_override_animation = true
		attached_obj.anim_player.play("thrown")
		if dir.x != 0:
			attached_obj.facing_dir.x = dir.x
		attached_obj.is_override_facing = true


func _physics_process(delta: float) -> void:
	if attached_obj:
		attached_obj.global_position = global_position
		attached_obj.linear_velocity = Vector2.ZERO
	if is_colliding_platform() or move_and_collide(dir.normalized() * speed * delta):
		if attached_obj.is_in_group("Player"):
			attached_obj.is_override_animation = false
			attached_obj.is_override_facing = false
		emit_signal("be_destroyed", attached_obj)
		queue_free()


func is_colliding_platform() -> bool:
	return platform_detection.is_colliding() and dir.y > 0
