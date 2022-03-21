extends KinematicBody2D

onready var timer = $Timer
onready var particles = $Particles2D

onready var cast = $RayCast2D
onready var cast2 = $RayCast2D2
onready var platform_detection = $PlatformDetection
onready var _ed = get_tree().get_nodes_in_group("Ed")[0]

var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")
var linear_velocity:Vector2

var _last_floor:bool
var _first_frame = true


func _ready() -> void:
	$Sprite.playing = true
	particles.emitting = true


func _physics_process(delta: float) -> void:
	if timer.time_left == 0:
		update_physics_platformer(delta)
	else:
		move_and_slide_with_snap(Vector2.ZERO, Vector2.DOWN * 2, Vector2.UP)


func update_physics_platformer(delta:float) -> void:
	linear_velocity.x = 0
	if is_on_floor():
		linear_velocity.y = 0
	else:
		linear_velocity.y += gravity * delta
	
	var last_pos = position
	linear_velocity = move_and_slide_with_snap(linear_velocity, Vector2.DOWN * 2, Vector2.UP)
	
	
	var is_belt:bool = false
	for i in range(get_slide_count()):
		var b = get_slide_collision(i).collider
		if b.is_in_group("Belt") or b.is_in_group("Moving"):
			is_belt = true
	
	if not is_belt:
		position.x -= get_floor_velocity().x * delta
		if is_on_floor() and not is_on_wall():
			position.x = last_pos.x
	
	for i in range(get_slide_count()):
		var b = get_slide_collision(i).collider
		if b.is_in_group("Breakable"):
			b.destroy()
	
	if _first_frame:
		_last_floor = is_on_floor()
		_first_frame = false
	
	if custom_is_on_floor() and custom_is_on_floor() != _last_floor:
		SoundManager.play_slime_drop_sfx()
	
	_last_floor = custom_is_on_floor()


func custom_is_on_floor() -> bool:
	if _ed.grabbed_body == self:
		return false
	return platform_detection.is_colliding() or cast.is_colliding() or cast2.is_colliding() or is_on_floor()


func _on_Timer_timeout() -> void:
	particles.emitting = false


func _on_Timer2_timeout() -> void:
	particles.emitting = false
