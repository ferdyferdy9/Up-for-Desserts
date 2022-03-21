extends Area2D

export(Array, NodePath) var target_paths:Array
export(bool) var start_active:bool

onready var sprite = $Sprite

var targets:Array
var _active:bool
var _last_active:bool

func _ready() -> void:
	for path in target_paths:
		var node = get_node_or_null(path)
		if node:
			targets.append(node)
	
	deactivate()


func _process(delta: float) -> void:
	_active = get_overlapping_bodies().size() > 0
	if _active != _last_active:
		if _active:
			activate()
	_last_active = _active


func activate() -> void:
	if sprite.frame != 1:
		$button.play()
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
