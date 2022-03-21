extends Control

export(NodePath) var target_path:NodePath

onready var red = $Red
onready var blue = $Blue
onready var gray = $Gray
onready var red_select = $RedSelect
onready var blue_select = $BlueSelect
onready var gray_select = $GraySelect
onready var target = get_node_or_null(target_path)

var selected_color = Color.white
var unselected_color = Color(0.6, 0.6, 0.6)


func _process(delta: float) -> void:
	if target == null:
		return
	
	match(target.idx):
		0:
			red.modulate = selected_color
			blue.modulate = unselected_color
			gray.modulate = unselected_color
			red_select.show()
			blue_select.hide()
			gray_select.hide()
		1:
			red.modulate = unselected_color
			blue.modulate = selected_color
			gray.modulate = unselected_color
			red_select.hide()
			blue_select.show()
			gray_select.hide()
		2:
			red.modulate = unselected_color
			blue.modulate = unselected_color
			gray.modulate = selected_color
			blue_select.hide()
			red_select.hide()
			gray_select.show()

