extends Sprite

export(NodePath) var target_path:NodePath

onready var target:Node2D = get_node_or_null(target_path)

func _process(delta: float) -> void:
	if target == null:
		return
	
	region_rect.size.x = global_position.distance_to(target.global_position)
	look_at(target.global_position)
