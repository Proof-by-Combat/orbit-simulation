extends Body

class_name Player

const _ACCELERATION: float = 10
const _TERMINAL: float = 50000
var _movement_input: Vector2


func _input(_event: InputEvent) -> void:
	var input_x: float = Input.get_axis(&"move_left", &"move_right")
	var input_y: float = Input.get_axis(&"move_up", &"move_down")
	_movement_input = Vector2(input_x, input_y).normalized()


#func _physics_process(delta: float) -> void:
	#velocity += _movement_input * _ACCELERATION
	#velocity = velocity.limit_length(_TERMINAL)
	#
	#simulate(delta)
