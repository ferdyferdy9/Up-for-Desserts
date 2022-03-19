extends Area2D

signal hit_something(who)

export(float) var speed:float = 1200

var is_active:bool = false
var dir:Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	if is_active:
		global_position += dir * speed * delta


func _on_Arrow_body_entered(body: Node) -> void:
	if is_visible_in_tree() and (body.collision_layer & collision_mask) != 0:
		emit_signal("hit_something", body) 
