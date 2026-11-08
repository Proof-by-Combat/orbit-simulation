extends Body

class_name Bullet

var _age: float = 0
#var _explosion_scene: PackedScene = preload("uid://dcmp5jpyb5o1a")


func _process(delta: float) -> void:
	_age += delta
	
	if _age >= 3:
		is_dead = true
	
	simulate(delta)
	global_rotation = velocity.angle()


func _on_area_2d_area_entered(_area: Area2D) -> void:
	#is_dead = true
	#var ref: Explosion = _explosion_scene.instantiate()
	#ref.global_position = global_position
	#add_sibling(ref)
	pass
