@tool
extends Attractor
class_name Planet

@export var start_velocity: Vector2 = Vector2(0.0, 0.0)

@onready var _sprite: Sprite2D = $"Sprite2D"

@warning_ignore("unused_private_class_variable")
@onready var _on_screen_notif: VisibleOnScreenNotifier2D = $"OnScreen"

var path: PathFollow2D = null

const POINTS_IN_PATH: int = 1000

func set_mass():
	mass = (4.0 / 3.0) * radius * radius * radius * PI * density

func _ready() -> void:
	if Engine.is_editor_hint():
		set_notify_transform(true)
	else:
		super()
		handle_child_planets()
		
		var spriteWidth: float = _sprite.get_rect().size.x
		radius = scale.x * spriteWidth / 2
		
		velocity = start_velocity
		set_mass()

func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		const speed = .1
		if get_parent() is PathFollow2D:
			get_parent().progress_ratio += delta * speed

func handle_child_planets():
	if get_parent() is Planet:
		print("adding ", name)
		
		var path_ref: Path2D = Path2D.new() 
		var follow_ref: PathFollow2D = PathFollow2D.new()
		
		add_sibling.call_deferred(path_ref)
		path_ref.add_child(follow_ref)
		path_ref.curve = generate_path(POINTS_IN_PATH)

		reparent.call_deferred(follow_ref)
	else:
		print("Not adding ", name)


func generate_path(num_of_points: int):
	var curve: Curve2D = Curve2D.new()
	modulate = Color.GREEN
	
	if not get_parent() is Planet:
		return
	
	print("Parent: ", get_parent().name)
	print("\t", position)
	print("\t", global_position)
	print("Child : ", name)
	
	var interval: float = 2 * PI / num_of_points
	var curr_angle: float = 0
	var center: Vector2 = get_parent().global_position - global_position 
	var distance: float = center.length()
	
	print("Distance: ", distance)
	var circle_point: Vector2
	for i in range(num_of_points):
		circle_point.x = cos(curr_angle) * distance + center.x
		circle_point.y = sin(curr_angle) * distance + center.y
		curr_angle += interval
		curve.add_point(circle_point)
	
	curve.add_point(Vector2(distance + center.x, center.y))
	return curve

func _draw() -> void:
	if not Engine.is_editor_hint():
		return
	
	var curve: Curve2D = generate_path(POINTS_IN_PATH)
	if curve == null:
		print("No path for ", name)
		return
	
	var array: PackedVector2Array = curve.get_baked_points()
	for i in range(array.size() - 1):
		draw_line(array[i], array[i + 1], Color.GREEN)
	draw_line(array[array.size() - 1], array[0], Color.GREEN)


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		queue_redraw()
