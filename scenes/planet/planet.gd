@tool
extends Attractor
class_name Planet


@export var orbit_speed: float = 0.05
@export var _texture: Texture2D :
	set(value):
		_texture = value
		if Engine.is_editor_hint():
			if !is_node_ready():
				await ready
			_sprite.texture = value
			
@export_group("Planet Data", "data_")
@export var data_planet_name: String = "PlaceHolder"

@onready var _sprite: Sprite2D = $"Sprite2D"
@onready var _collision: Area2D = $"HitZone"


@warning_ignore("unused_private_class_variable")
@onready var _on_screen_notif: VisibleOnScreenNotifier2D = $"OnScreen"

var path: PathFollow2D = null
var _guard: bool = false
const POINTS_IN_PATH: int = 1000

func _set_mass(value: float):
	super(value)
	if _guard:
		return
	_guard = true
	density = mass / ((4.0 / 3.0) * radius * radius * radius * PI)
	_guard = false

func _set_density(value: float):
	super(value)
	if _guard:
		return
	_guard = true
	mass = (4.0 / 3.0) * radius * radius * radius * PI * density
	_guard = false

func _set_radius(value: float):
	super(value)
	if _guard:
		return
	_guard = true
	mass = (4.0 / 3.0) * radius * radius * radius * PI * density
	scale = Vector2(radius, radius)
	for child in get_children():
		if child is Planet or child is VisibleOnScreenEnabler2D or child is Path2D:
			child.scale = Vector2(1 / radius, 1 / radius)
	
	_guard = false

func _ready() -> void:
	if Engine.is_editor_hint():
		set_notify_transform(true)
	else:
		super()
		handle_child_planets()
		
		if _texture:
			_sprite.texture = _texture
		var spriteWidth: float = _sprite.get_rect().size.x
		radius = scale.x * spriteWidth / 2

func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if path != null:
			path.progress_ratio += delta * orbit_speed
			_sprite.global_rotation = 0

func handle_child_planets():
	if get_parent() is Planet:
		
		var path_ref := Path2D.new() 
		var follow_ref := PathFollow2D.new()
		var remote := RemoteTransform2D.new()
		
		remote.remote_path = self.get_path()
		
		add_sibling.call_deferred(path_ref)
		path_ref.add_child(follow_ref)
		path_ref.curve = generate_path(POINTS_IN_PATH)
		follow_ref.add_child(remote)
		
		path = follow_ref


func generate_path(num_of_points: int, offset: Vector2 = Vector2.ZERO):
	var curve: Curve2D = Curve2D.new()
	
	if not get_parent() is Planet:
		return
	
	var interval: float = 2 * PI / num_of_points
	var curr_angle: float = 0
	var distance: float = position.length()
	
	var circle_point: Vector2
	for i in range(num_of_points):
		circle_point.x = cos(curr_angle) * distance + offset.x
		circle_point.y = sin(curr_angle) * distance + offset.y
		curr_angle += interval
		curve.add_point(circle_point)
	
	curve.add_point(Vector2(distance, 0) + offset)
	return curve

func _draw() -> void:
	if not Engine.is_editor_hint():
		return
	
	var curve: Curve2D = generate_path(POINTS_IN_PATH, -position)
	if curve == null:
		return
	
	var array: PackedVector2Array = curve.get_baked_points()
	array.append(array[0])
	
	draw_polyline(array, Color.GREEN)


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		queue_redraw()


func _on_hit_zone_body_entered(body: Node2D) -> void:
	if (body is Bullet):
		body.explode_and_die()
