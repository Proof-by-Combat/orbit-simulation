extends Body

class_name Player

const _ACCELERATION: float = 10
const _FRICTION: float = 5
const _MAX_MOVEMENT_SPEED: float = 100
# NOTE: _MAX_MOVEMENT_SPEED is not the terminal velocity.
# It is the maximum speed input can take you to.

var _movement_input: Vector2
var _braking: bool
var _goal_zoom: float = 1

@onready var _sprite: Sprite2D = $"Sprite2D"
@onready var _camera: Camera2D = $"Camera2D"


func _ready() -> void:
	super()


func _input(_event: InputEvent) -> void:
	if _event.is_action_pressed("ui_accept"):
		velocity = Vector2.ZERO
	
	var input_x: float = Input.get_axis(&"move_left", &"move_right")
	var input_y: float = Input.get_axis(&"move_up", &"move_down")
	_braking = Input.is_action_pressed(&"brake")
	_movement_input = Vector2(input_x, input_y).normalized()


func _handle_zoom(delta: float) -> void:
	const ZOOM_AMOUNT: float = 0.25
	var zoom_increment: float = 1-ZOOM_AMOUNT
	
	if Input.is_action_just_pressed(&"zoom_in"):
		_goal_zoom *= 1.0 / zoom_increment
		
	elif Input.is_action_just_pressed(&"zoom_out"):
		_goal_zoom *= zoom_increment
	
	const ZOOM_INTERP: float = 10
	_camera.zoom.x = lerp(_camera.zoom.x, _goal_zoom, 1-exp(-delta*ZOOM_INTERP))
	_camera.zoom.y = _camera.zoom.x
	


func simulate(delta: float) -> void:
	
	var additional: Vector2 = _movement_input * _ACCELERATION
	#var dot: float = velocity.normalized().dot(_movement_input.normalized())
	#
	#if dot <= 0:
		#velocity += additional
	#else:
		#velocity += (1-dot) * additional
	
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
	
	super(delta)
	
	_handle_zoom(delta)
