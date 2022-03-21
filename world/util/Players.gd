extends Node2D

export(int) var idx:int = 2

onready var players = [
	$Jeff,
	$Jack,
	$Ed,
]
onready var camera_follow = $CameraFollow


func _ready() -> void:
	update_players()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("switch_forward"):
		idx = (idx + 1 + 3) % 3
		$AudioStreamPlayer.play()
		update_players()
	if Input.is_action_just_pressed("switch_backward"):
		idx = (idx - 1 + 3) % 3
		$AudioStreamPlayer.play()
		update_players()


func update_players():
	for i in range(3):
		if i == idx:
			camera_follow.follow_target = players[idx]
		players[i].is_controlled = (i == idx)
		players[i].order = (idx-i+3) % 3
		players[i].z_index = -players[i].order
		players[i].input_vector.x = 0
		players[i].modulate = Color.white if (i == idx) else Color(0.66, 0.66, 0.66)
