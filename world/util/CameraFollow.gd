class_name CameraFollow
extends Camera2D

export(NodePath) var follow_target_path:NodePath
export(float) var speed:float = 4

onready var follow_target:Node2D = get_node_or_null(follow_target_path)


func _ready() -> void:
	current = true


func _process(delta: float) -> void:
	if follow_target == null:
		return
	
	var dist:float = follow_target.global_position.distance_to(global_position)
	global_position = global_position.move_toward(
		follow_target.global_position, 
		dist * speed * delta
	)
