extends Attractee

class_name Player

const _ACCELERATION: float = 10
const _BRAKE: float = 5
#const _MAX_INPUT_SPEED: float = 100
# NOTE: _MAX_INPUT_SPEED is NOT the terminal velocity.
# It is the maximum speed input can take you up to.

var _movement_input: Vector2
var _braking: bool = false

var _goal_zoom: float = 1
var _shooting: bool = false

var _shoot_cooldown: float = 0

@onready var camera: PlayerCamera = $"Camera2D"
@onready var _sprite: Sprite2D = $"ShipSprite"
@onready var _gun_sprite: Sprite2D = $"GunSprite"
@onready var _flare_sprite: Sprite2D = $"ShipSprite/FlareSprite"

var bullet_scene: PackedScene = preload("uid://chb1ivd6bmhc2")
var _explosion_scene: PackedScene = preload("uid://dcmp5jpyb5o1a")

func _ready() -> void:
	PlayerStats.currentPlayer = self
	bother_with_collision = true
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
	
	_goal_zoom = clampf(_goal_zoom, 1.0/8.0, 5)
	
	const ZOOM_INTERP: float = 10
	camera.zoom.x = lerp(camera.zoom.x, _goal_zoom, 1-exp(-delta*ZOOM_INTERP))
	camera.zoom.y = camera.zoom.x


func _handle_shooting(delta: float) -> void:
	var to_mouse: Vector2 = get_global_mouse_position() - global_position
	_gun_sprite.rotation = to_mouse.angle()
	
	if _shooting:
		if _shoot_cooldown <= 0:
			_shoot_cooldown = 0.25
			
			const BULLET_SPEED: float = 1000
			const BARREL_OFFSET_LENGTH: float = 12
			var barrel_offset = Vector2(0, BARREL_OFFSET_LENGTH)
			barrel_offset = barrel_offset.rotated(to_mouse.angle())
			
			var ref: Bullet
			
			ref = bullet_scene.instantiate()
			ref.velocity = to_mouse.normalized() * BULLET_SPEED
			ref.global_position = global_position + barrel_offset
			add_sibling(ref)
			
			ref = bullet_scene.instantiate()
			ref.velocity = to_mouse.normalized() * BULLET_SPEED
			ref.global_position = global_position - barrel_offset
			add_sibling(ref)
	
	_gun_sprite.position = -to_mouse.normalized() * _shoot_cooldown * 32
	
	_shoot_cooldown = move_toward(_shoot_cooldown,0,delta)


func _handle_movement(delta: float) -> void:
	var additional: Vector2 = _movement_input * _ACCELERATION
	
	if _braking:
		var temp_velocity: Vector2 = velocity
		velocity -= velocity.normalized() * _BRAKE
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


func _handle_flare() -> void:
	if _movement_input and !_braking:
		_flare_sprite.scale.y = velocity.length() / 1000
		_flare_sprite.scale.y += randf_range(-1,1)
	else:
		_flare_sprite.scale.y = 0


func _explode_and_die() -> void:
	var ref: Explosion = _explosion_scene.instantiate()
	ref.global_position = global_position
	add_sibling(ref)
	
	camera.position_smoothing_enabled = false
	camera.call_deferred("shake",1000,2)
	camera.reparent(get_parent())
	queue_free()


func simulate(delta: float) -> void:
	_handle_movement(delta)
	super(delta)
	
	_handle_shooting(delta)
	_handle_flare()
	_handle_zoom(delta)


func _notification(event: int) -> void:
	if event == NOTIFICATION_PREDELETE:
		PlayerStats.currentPlayer = null


func _on_hit_area_body_entered(_body: Node2D) -> void:
	_explode_and_die()


func _on_hit_area_area_entered(_area: Area2D) -> void:
	_explode_and_die()
