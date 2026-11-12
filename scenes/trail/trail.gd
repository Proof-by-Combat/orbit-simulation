extends MeshInstance2D

class_name Trail

@export_range(4,0,1,"or_greater") var number_of_points: int = 10
@export_range(0,1,0.001,"or_greater", "suffix:seconds") var interval: float = 1.0/60.0
@export var starting_width: float = 64
@export var falloff_curve: Curve

@onready var _immediate: ImmediateMesh = mesh
@onready var _death_timer: Timer = $"DeathTimer"

var _points: Array[Vector2]
var _tail: int = 0
var _timer: float = 0
var _take_new_points: bool = true


func _ready() -> void:
	_points.resize(number_of_points)
	_points.fill(global_position)
	_timer = interval


func _add_point() -> void:
	if !_take_new_points:
		_points[_tail] = _points[ wrap(_tail-1, 0, number_of_points) ]
		_tail = (_tail + 1)  % number_of_points
		return
	
	var parent = get_parent()
	assert(parent != null, "Trail must have a parent Node2D.")
	assert(parent is Node2D, "Parent of Trail must be of type Node2D.")
	var parent_as_node2D: Node2D = parent
	
	_points[_tail] = parent_as_node2D.global_position
	_tail = (_tail + 1)  % number_of_points


func _rerender() -> void:
	_immediate.clear_surfaces()
	_immediate.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	
	var current: int = _tail
	var end: int = wrapi(_tail-1,0,number_of_points)
	var progress: int = 0
	
	while current != end:
		
		var next: int = wrap(current+1, 0, number_of_points)
		
		var base_point: Vector2 = _points[current]
		var next_point: Vector2 = _points[next]
		
		var base_ratio = 1-(progress/float(number_of_points))
		
		var next_ratio = 1-((progress+1)/float(number_of_points))
		var next_sample: float = falloff_curve.sample(next_ratio)
		next_sample *= starting_width / 2
		
		var toNext: Vector2 = next_point - base_point
		toNext = toNext.normalized()
		
		var offset := Vector2(-toNext.y, toNext.x) * next_sample
		
		var renderColor: Color = modulate
		renderColor.a *= falloff_curve.sample(base_ratio)
		_immediate.surface_set_color(renderColor)
		
		renderColor = modulate
		renderColor.a *= falloff_curve.sample(next_ratio)
		_immediate.surface_set_color(renderColor)
		_immediate.surface_add_vertex_2d(next_point + offset)
		_immediate.surface_add_vertex_2d(next_point - offset)
		
		current = next
		progress += 1
	
	_immediate.surface_end()


func stop_taking_new_points() -> void:
	if !_take_new_points: return
	
	_take_new_points = false
	_death_timer.start(number_of_points * interval)


func _process(delta: float) -> void:
	if interval == 0 or _timer >= interval:
		_add_point()
		_timer -= interval
	
	_rerender()
	
	_timer += delta


func _on_death_timer_timeout() -> void:
	queue_free()
