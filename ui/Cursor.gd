extends TextureRect

var is_selected:bool = false setget set_is_selected

func _ready() -> void:
	self.is_selected = is_selected


func set_is_selected(new_selected):
	is_selected = new_selected
	
	modulate.a = 1.0 if is_selected else 0.0
