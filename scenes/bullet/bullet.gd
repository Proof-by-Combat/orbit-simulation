extends Body

class_name Bullet

var _age: float = 0

func _process(delta: float) -> void:
	_age += delta
	
	if _age >= 3:
		is_dead = true
	
	simulate(delta)
