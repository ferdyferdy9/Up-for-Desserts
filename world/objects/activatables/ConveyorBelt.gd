extends StaticBody2D

export(bool) var is_flipped:bool = false
export(float) var speed:float = 120

onready var sprite = $Sprite

func _process(delta: float) -> void:
	constant_linear_velocity.x = speed * (-1 if is_flipped else 1)
	sprite.flip_h = is_flipped


func activate():
	is_flipped = true


func deactivate():
	is_flipped = false
