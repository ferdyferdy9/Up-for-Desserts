extends "res://world/player/Player.gd"

export(Vector2) var hold_offset = Vector2(0, -48)

onready var grab_area = $GrabArea
onready var ray_cast = $RayCast2D
onready var throw_delay = $ThrowDelayTimer

var flying_obj_scene = preload("res://world/player/obj/FlyingObj.tscn")
var grabbed_body:Node2D
var thrown_obj:Array

var is_throwing:bool


func _process(delta: float) -> void:
	if !is_instance_valid(grabbed_body):
		grabbed_body = null
	if is_controlled:
		if grabbed_body and grabbed_body.is_in_group("Jeff") and grabbed_body.grapple.is_swing:
			var isThrow:bool
			isThrow = isThrow or Input.is_action_just_pressed("jump") 
			isThrow = isThrow or Input.is_action_just_pressed("attack")
			if isThrow:
				grabbed_body.set_physics_process(true)
				grabbed_body.remove_collision_exception_with(self)
				grabbed_body = null
				is_override_animation = true
				anim_player.play("throw_down")
				SoundManager.play_throw()
				jump()
		else:
			var isThrowDown:bool
			isThrowDown = isThrowDown or Input.is_action_just_pressed("jump") 
			isThrowDown = isThrowDown or (Input.is_action_pressed("ui_down") and Input.is_action_just_pressed("attack"))
			if isThrowDown and not is_on_floor():
				if grabbed_body != null:
					create_thrown_body(Vector2.DOWN)
					jump()
					is_override_animation = true
					anim_player.play("throw_down")
					SoundManager.play_throw()
			elif Input.is_action_just_pressed("attack"):
				if grabbed_body == null:
					grabbed_body = get_closest()
					if grabbed_body:
						is_override_animation = true
						anim_player.play("grab")
						SoundManager.play_grab()
						grabbed_body.linear_velocity = Vector2.ZERO
						grabbed_body.set_physics_process(false)
						grabbed_body.add_collision_exception_with(self)
						if grabbed_body.is_in_group("Player"):
							grabbed_body.is_override_animation = true
							grabbed_body.anim_player.play("hurt_grabbed")
				elif can_throw() and not is_throwing:
					is_throwing = true
					is_override_animation = true
					anim_player.play("throw_side")
					throw_delay.start()
					SoundManager.play_throw()
					yield(throw_delay, "timeout")
					is_throwing = false
					create_thrown_body(Vector2(facing_dir.x, 0))
	
	if facing_dir.x > 0:
		grab_area.scale.x = 1
		ray_cast.scale.x = 1
		if grabbed_body and grabbed_body.is_in_group("Player"):
			grabbed_body.facing_dir.x = 1
	elif facing_dir.x < 0:
		grab_area.scale.x = -1
		ray_cast.scale.x = -1
		if grabbed_body and grabbed_body.is_in_group("Player"):
			grabbed_body.facing_dir.x = -1


func _physics_process(delta:float) -> void:
	if !is_instance_valid(grabbed_body):
		grabbed_body = null
	if grabbed_body:
		if grabbed_body.is_in_group("Jeff"):
			if grabbed_body.grapple.is_swing:
				if is_controlled:
					grabbed_body.apply_input(get_desired(delta), delta)
				return
		grabbed_body.global_position = global_position + hold_offset
		grabbed_body.linear_velocity = Vector2.ZERO


func create_thrown_body(dir):
	var obj = flying_obj_scene.instance()
	obj.connect("be_destroyed", self, "_on_throw_hit")
	obj.global_position = global_position
	obj.attached_obj = grabbed_body
	obj.dir = dir
	obj.add_collision_exception_with(grabbed_body)
	obj.add_collision_exception_with(self)
	get_parent().get_parent().add_child(obj)
	thrown_obj.append(grabbed_body)
	grabbed_body = null


func _on_throw_hit(body) -> void:
	body.remove_collision_exception_with(self)
	body.set_physics_process(true)
	thrown_obj.erase(body)


func can_throw():
	if ray_cast.is_colliding():
		var b = ray_cast.get_collider()
		if b.is_in_group("Player") and grabbed_body.is_in_group("Player"):
			return true
		if b != self and not b in thrown_obj and b != grabbed_body:
			return false
	return true


func get_closest():
	var bodies = grab_area.get_overlapping_bodies()
	var closest = null
	for b in bodies:
		if b == self:
			continue
		if !b.is_in_group("Pickable"):
			continue
		if b in thrown_obj:
			continue
		if closest == null:
			closest = b
		else:
			var c_dist = closest.global_position.distance_squared_to(global_position)
			var n_dist = b.global_position.distance_squared_to(global_position)
			if c_dist > n_dist:
				closest = b
	return closest


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	is_override_animation = false
