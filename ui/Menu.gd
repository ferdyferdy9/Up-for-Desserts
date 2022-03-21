extends VBoxContainer

signal selected(idx)

export(Array, NodePath) var cursor_paths:Array
export(bool) var is_active:bool
export(int) var index:int setget set_index

var cursors:Array

func _ready() -> void:
	for path in cursor_paths:
		var cursor = get_node_or_null(path)
		if cursor:
			cursors.append(cursor)
	
	self.index = index


func _process(delta: float) -> void:
	if is_active:
		if Input.is_action_just_pressed("ui_up"):
			self.index = max(0, index-1)
			SoundManager.play_grab()
		if Input.is_action_just_pressed("ui_down"):
			self.index = min(cursors.size()-1, index+1)
			SoundManager.play_grab()
		if Input.is_action_just_pressed("ui_accept"):
			emit_signal("selected", index)


func set_index(new_idx):
	index = new_idx
	
	for i in range(cursors.size()):
		cursors[i].is_selected = (i==index)
