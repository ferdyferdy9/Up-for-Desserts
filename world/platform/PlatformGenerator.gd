extends Node2D

var platform_scene := preload("res://world/platform/Platform.tscn")

func _ready() -> void:
	var tilemap:TileMap = $PlatformTile
	tilemap.hide()
	
	for pos in tilemap.get_used_cells():
		var platform = platform_scene.instance()
		platform.position = tilemap.map_to_world(pos)
		add_child(platform)
