extends Attractee

class_name Bullet

var _small_burst_scene: PackedScene = preload("uid://3rjpyg8vtylb")
var _age: float = 0


func simulate(delta: float) -> void:
	_age += delta
	
	if _age >= 3:
		queue_free()
	
	super(delta)
	
	global_rotation = velocity.angle()


func _on_area_2d_body_entered(_body: Node2D) -> void:
	var burst: OneShotParticle = _small_burst_scene.instantiate()
	burst.global_position = global_position
	add_sibling(burst)
	queue_free()
