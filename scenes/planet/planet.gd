@tool
extends Attractor
class_name Planet

@export var start_velocity: Vector2 = Vector2(0.0, 0.0)

@onready var _sprite: Sprite2D = $"Sprite2D"

@warning_ignore("unused_private_class_variable")
@onready var _on_screen_notif: VisibleOnScreenNotifier2D = $"OnScreen"

func set_mass():
	mass = (4.0 / 3.0) * radius * radius * radius * PI * density

	


func _ready() -> void:
	if Engine.is_editor_hint():
		set_notify_transform(true)
	else:
		super()
		
		var spriteWidth: float = _sprite.get_rect().size.x
		radius = scale.x * spriteWidth / 2
		
		velocity = start_velocity
		set_mass()

func _process(delta: float) -> void:
	pass

func generate_path(num_of_points: int):
	var curve: Curve2D = Curve2D.new()
	modulate = Color.GREEN
	

	#var orbitee: Planet
	#for child in get_children():
		#if child is Planet:
			#orbitee = child
			#break
	#
	#
	#if orbitee == null:
		#return null
	
	if not get_parent() is Planet:
		return
	
	print("Parent: ", get_parent().name)
	print("Child : ", name)
	
	var interval: float = 2 * PI / num_of_points
	var curr_angle: float = 0
	var center: Vector2 = get_parent().global_position - global_position 
	var radius: float = center.length()
	
	print("Radius: ", radius)
	var circle_point: Vector2
	for i in range(num_of_points):
		circle_point.x = cos(curr_angle) * radius + center.x
		circle_point.y = sin(curr_angle) * radius + center.y
		curr_angle += interval
		curve.add_point(circle_point)
	
	curve.add_point(Vector2(radius + center.x, center.y))
	return curve

func _draw() -> void:
	if not Engine.is_editor_hint():
		return
	
	var curve: Curve2D = generate_path(30)
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
