extends "res://world/player/Player.gd"

var slime_rock_scene = preload("res://world/player/obj/SlimeRock.tscn")

var is_rock:bool

var _rock
onready var _ed = get_tree().get_nodes_in_group("Ed")[0]


func _process(delta: float) -> void:
	if is_rock and _rock:
		global_position.y = _rock.global_position.y
	
	if _rock:
		_rock.modulate = modulate
	
	if is_controlled and Input.is_action_just_pressed("jump"):
		if _ed.grabbed_body == self:
			_ed.grabbed_body = null
			_ed.remove_collision_exception_with(self)
			set_physics_process(true)
			jump()
	
	if is_controlled and Input.is_action_just_pressed("attack"):
		if !is_rock:
			_rock = slime_rock_scene.instance()
			_rock.add_collision_exception_with(self)
			_rock.linear_velocity = Vector2(0, 800)
			get_parent().get_parent().add_child(_rock)
			_rock.global_position = global_position
			
			is_rock = true
			set_physics_process(false)
			linear_velocity = Vector2.ZERO
			global_position.x = -32
			
			if _ed.grabbed_body == self:
				_ed.grabbed_body = _rock
				_rock.add_collision_exception_with(_ed)
		else:
			if _rock:
				if _ed.grabbed_body == _rock:
					_ed.grabbed_body = self
					_ed.add_collision_exception_with(self)
				global_position = _rock.global_position
				linear_velocity = _rock.linear_velocity
				_rock.queue_free()
				_rock = null
			set_physics_process(true)
			is_rock = false
			
