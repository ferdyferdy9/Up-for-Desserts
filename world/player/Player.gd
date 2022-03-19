extends KinematicBody2D

export(bool) var is_controlled:bool = false
export(int) var order = 0

export(float) var move_accel:float = 30
export(float) var move_deaccel:float = 50
export(float) var max_move_speed:float = 250
export(float) var jump_strength:float = 900
export(float) var drop_offset:float = 3
export(float) var drop_timer:float = 0.1

onready var platform_detection = $PlatformDetection

var input_vector:Vector2
var linear_velocity:Vector2
var facing_dir:Vector2 = Vector2.RIGHT
var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")

var _platform:Node

func _process(delta: float) -> void:
	if is_controlled:
		update_input_platformer(delta)
		
		if input_vector.x > 0:
			facing_dir.x = 1
		elif input_vector.x < 0:
			facing_dir.x = -1
		facing_dir.y = sign(input_vector.y)


func is_on_platform() -> bool:
	return platform_detection.is_colliding()


func _physics_process(delta: float) -> void:
	update_physics_platformer(delta)


func jump() -> void:
	linear_velocity.y = -jump_strength


func update_input_platformer(delta:float) -> void:
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
	
	if Input.is_action_just_pressed("ui_down"):
		if is_on_platform():
			position.y += drop_offset
			linear_velocity.y = drop_offset * 20
			set_collision_mask_bit(8, false)
			yield(get_tree().create_timer(drop_timer), "timeout")
			set_collision_mask_bit(8, true)


func update_physics_platformer(delta:float) -> void:
	var desired:float = get_desired(delta)
	apply_input(desired, delta)
	
	if !is_on_floor():
		linear_velocity.y += gravity * delta
	
	linear_velocity = move_and_slide_with_snap(
		linear_velocity, Vector2.DOWN * 2, Vector2.UP
	)


func get_desired(delta) -> float:
	if input_vector.x == 0:
		return 0.0
	else:
		return input_vector.x * max_move_speed * 60 * delta


func apply_input(desired, delta) -> void:
	linear_velocity = linear_velocity.move_toward(
		Vector2(desired, linear_velocity.y),
		(move_accel if input_vector.x != 0 else move_deaccel) * 60 * delta
	)
