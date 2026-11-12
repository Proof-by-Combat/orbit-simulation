@tool
extends Path2D
const NUM_OF_POINTS = 100

func _ready() -> void:
	if Engine.is_editor_hint():
		position = Vector2(0, 0)
		if get_parent() is Planet:
			generate_path()
		else:
			curve.clear_points()
			
			
	if not Engine.is_editor_hint():
		var new_parent: PathFollow2D
		for child in get_children():
			if child is PathFollow2D:
				new_parent = child
				break;
				
		for child in get_children():
			if child is not PathFollow2D:
				child.reparent(new_parent)

func _enter_tree() -> void:
	position = Vector2(0, 0)
	if Engine.is_editor_hint():
		if get_parent() is Planet:
			generate_path()
		else:
			curve.clear_points()


func generate_path():
	
	curve = Curve2D.new()
	modulate = Color.GREEN
	

	var orbitee: Planet
	for child in get_children():
		if child is Planet:
			orbitee = child
			break
	
	if orbitee == null:
		return
	
	print("Parent: ", get_parent().name)
	print("Child : ", orbitee.name)
	
	var interval: float = 2 * PI / NUM_OF_POINTS
	var curr_angle: float = 0
	var center: Vector2 = orbitee.global_position - get_parent().global_position 
	var radius: float = center.length()
	
	print("Radius: ", radius)
	var circle_point: Vector2
	for i in range(NUM_OF_POINTS):
		circle_point.x = cos(curr_angle) * radius
		circle_point.y = sin(curr_angle) * radius
		curr_angle += interval
		curve.add_point(circle_point)
	
	curve.add_point(Vector2(radius, 0))
	#curve.add_point(Vector2(0, 0))
	#curve.add_point(Vector2(0, 0))
	#curve.add_point(Vector2(center.x, center.y))
	#curve.add_point(Vector2(0, 0))
	#curve.add_point(-get_parent().global_position)
	#curve.add_point(orbitee.global_position - get_parent().global_position)
	#curve.add_point(Vector2(0, 0))

func draw_path():
	for point in curve.get_baked_points():
		print(point)
