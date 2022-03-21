extends Control

signal selected(idx)

export(int) var index:int setget set_index


func _ready() -> void:
	self.index = 0


func set_index(new_idx):
	index = new_idx
	
	var children = get_children()
	for i in range(children.size()):
		children[i].visible = (i==index)
