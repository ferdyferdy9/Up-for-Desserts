extends Node

signal fade_in_finished
signal fade_out_finished

onready var tree = get_tree()
onready var anim_player = $AnimationPlayer


func fade_in():
	anim_player.play("fade_in")


func fade_out():
	anim_player.play("fade_out")


func fade_out_with_pause():
	pause_game()
	if anim_player.current_animation == "fade_in":
		yield(self, "fade_in_finished")
	fade_out()
	connect("fade_out_finished", self, "unpause_game", [], CONNECT_ONESHOT)
	connect("fade_out_finished", self, "fade_in", [], CONNECT_ONESHOT)


func pause_game():
	tree.paused = true


func unpause_game():
	tree.paused = false


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	match(anim_name):
		"fade_in":
			emit_signal("fade_in_finished")
		"fade_out":
			emit_signal("fade_out_finished")
