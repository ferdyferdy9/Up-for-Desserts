extends Node2D

export(NodePath) var track_node_path:NodePath
export(float) var speed:float = 20
export(int) var max_points:int = 10

onready var track_node:Node2D = get_node_or_null(track_node_path)

var points:PoolVector2Array


func _ready() -> void:
	global_position = track_node.global_position
	points.resize(max_points)
	for i in range(points.size()):
		points[i] = global_position


func _process(delta: float) -> void:
	var dist:float = track_node.global_position.distance_to(global_position)
	global_position = track_node.global_position
	if points.size() >= max_points:
		points.remove(0)
	points.push_back(global_position)
