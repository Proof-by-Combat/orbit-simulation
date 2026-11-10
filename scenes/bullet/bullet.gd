extends Attractee

class_name Bullet

var _age: float = 0


func simulate(delta: float) -> void:
	_age += delta
	
	if _age >= 3:
		queue_free()
	
	super(delta)
	
	global_rotation = velocity.angle()


func _on_area_2d_body_entered(_body: Node2D) -> void:
	queue_free()
