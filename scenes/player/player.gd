extends Body

class_name Player

const _ACCELERATION: float = 10
const _FRICTION: float = 5
const _MAX_MOVEMENT_SPEED: float = 100
# NOTE: _MAX_MOVEMENT_SPEED is not the terminal velocity.
# It is the maximum speed input can take you to.

var _movement_input: Vector2
var _braking: bool = false

var _goal_zoom: float = 1
var _shooting: bool = false

var _shoot_cooldown: float = 0

@onready var _sprite: Sprite2D = $"Sprite2D"
@onready var _camera: Camera2D = $"Camera2D"
@onready var _gun_sprite: Sprite2D = $"GunSprite"

var bullet_scene: PackedScene = preload("uid://chb1ivd6bmhc2")


func _ready() -> void:
	super()


func _input(_event: InputEvent) -> void:
	var input_x: float = Input.get_axis(&"move_left", &"move_right")
	var input_y: float = Input.get_axis(&"move_up", &"move_down")
	_braking = Input.is_action_pressed(&"brake")
	_shooting = Input.is_action_pressed(&"shoot")
	_movement_input = Vector2(input_x, input_y).normalized()


func _handle_zoom(delta: float) -> void:
	const ZOOM_AMOUNT: float = 0.25
	var zoom_increment: float = 1-ZOOM_AMOUNT
	
	if Input.is_action_just_pressed(&"zoom_in"):
		_goal_zoom *= 1.0 / zoom_increment
		
	elif Input.is_action_just_pressed(&"zoom_out"):
		_goal_zoom *= zoom_increment
	
	_goal_zoom = clampf(_goal_zoom, 0.25, 5)
	
	const ZOOM_INTERP: float = 10
	_camera.zoom.x = lerp(_camera.zoom.x, _goal_zoom, 1-exp(-delta*ZOOM_INTERP))
	_camera.zoom.y = _camera.zoom.x
	


func simulate(delta: float) -> void:
	
	var additional: Vector2 = _movement_input * _ACCELERATION
	
	if _braking:
		var temp_velocity: Vector2 = velocity
		velocity -= velocity.normalized() * _FRICTION
		if velocity.dot(temp_velocity) < 0:
			velocity = Vector2.ZERO
	else:
		velocity += additional
	
	if _movement_input != Vector2.ZERO:
		_sprite.rotation = lerp_angle(
			_sprite.rotation,
			_movement_input.angle(),
			1-exp(-delta * 10)
		)
	
	var to_mouse: Vector2 = get_global_mouse_position() - global_position
	_gun_sprite.rotation = to_mouse.angle()
	
	if _shooting:
		if _shoot_cooldown <= 0:
			_shoot_cooldown = 0.25
			
			var ref: Bullet = bullet_scene.instantiate()
			const BULLET_SPEED: float = 500
			ref.velocity = to_mouse.normalized() * BULLET_SPEED
			ref.global_position = global_position
			ref.global_rotation = to_mouse.angle()
			add_sibling(ref)
	
	_gun_sprite.position = -to_mouse.normalized() * _shoot_cooldown * 32
	
	_shoot_cooldown = move_toward(_shoot_cooldown,0,delta)
	
	super(delta)
	
	_handle_zoom(delta)
