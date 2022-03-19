extends KinematicBody2D

signal be_destroyed(attached_obj)

export(float) var speed:float = 600

onready var platform_detection = $PlatformDetection

var attached_obj:Node2D
var dir:Vector2 = Vector2.RIGHT


func _physics_process(delta: float) -> void:
	if attached_obj:
		attached_obj.global_position = global_position
		attached_obj.linear_velocity = Vector2.ZERO
	if is_colliding_platform() or move_and_collide(dir.normalized() * speed * delta):
		emit_signal("be_destroyed", attached_obj)
		queue_free()


func is_colliding_platform() -> bool:
	return platform_detection.is_colliding() and dir.y > 0
