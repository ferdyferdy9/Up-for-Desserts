extends KinematicBody2D

var dir:Vector2 = Vector2.RIGHT
var hit_scene = preload("res://world/objects/Hit.tscn")


func _ready() -> void:
	$Sprite.playing = true


func _physics_process(delta: float) -> void:
	var collision = move_and_collide(dir * delta)
	if collision:
		var hit_obj = hit_scene.instance()
		get_parent().add_child(hit_obj)
		hit_obj.global_position = global_position
		
		if collision.collider.is_in_group("Player"):
			get_tree().reload_current_scene()
		queue_free()
