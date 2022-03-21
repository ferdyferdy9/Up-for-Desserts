extends KinematicBody2D

export(Array, NodePath) var target_paths:Array
export(bool) var start_active:bool

onready var sprite = $Sprite

var targets:Array

func _ready() -> void:
	for path in target_paths:
		var node = get_node_or_null(path)
		if node:
			targets.append(node)
	
	deactivate()


func activate() -> void:
	if sprite.frame != 1:
		$AudioStreamPlayer.play()
	sprite.frame = 1
	if start_active:
		set_switch(false)
	else:
		set_switch(true)


func deactivate() -> void:
	sprite.frame = 0
	if start_active:
		set_switch(true)
	else:
		set_switch(false)


func set_switch(isActive) -> void:
	if isActive:
		for t in targets:
			t.activate()
	else:
		for t in targets:
			t.deactivate()
