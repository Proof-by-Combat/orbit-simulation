extends Body

class_name Player

const _ACCELERATION: float = 10
const _FRICTION: float = 5
const _MAX_MOVEMENT_SPEED: float = 100
# NOTE: _MAX_MOVEMENT_SPEED is not the terminal velocity.
# It is the maximum speed input can take you to.

var _movement_input: Vector2
var _braking: bool

@onready var _sprite: Sprite2D = $"Sprite2D"


func _ready() -> void:
	super()


func _input(_event: InputEvent) -> void:
	if _event.is_action_pressed("ui_accept"):
		velocity = Vector2.ZERO
	
	var input_x: float = Input.get_axis(&"move_left", &"move_right")
	var input_y: float = Input.get_axis(&"move_up", &"move_down")
	_braking = Input.is_action_pressed(&"brake")
	_movement_input = Vector2(input_x, input_y).normalized()


func simulate(delta: float) -> void:
	
	var additional = _movement_input * _ACCELERATION
	velocity += additional
	
	if _braking:
		var temp_velocity: Vector2 = velocity
		velocity -= velocity.normalized() * _FRICTION
		if velocity.dot(temp_velocity) < 0:
			velocity = Vector2.ZERO
	
	if _movement_input != Vector2.ZERO:
		_sprite.rotation = lerp_angle(
			_sprite.rotation,
			_movement_input.angle(),
			1-exp(-delta * 10)
		)
	
	super(delta)
	
	queue_redraw()


#func _draw() -> void:
	#draw_circle(Vector2.ZERO, _MAX_MOVEMENT_SPEED, Color.RED, false)
	#draw_line(Vector2.ZERO, velocity, Color.BLUE)
	#draw_line(Vector2.ZERO, _movement_input, Color.GREEN)
