extends MeshInstance2D

class_name Trail

@onready var _immediate: ImmediateMesh = mesh
const _NUMBER_OF_POINTS: int = 20
var _points: Array[Vector2]


func _ready() -> void:
	_points.resize(_NUMBER_OF_POINTS)
	_points.fill(global_position)


func _process(delta: float) -> void:
	pass
