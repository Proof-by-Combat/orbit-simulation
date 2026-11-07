extends Node

const G: float = 1

var bodies: Array[Body]

func _physics_process(delta: float) -> void:
	for body in bodies:
		body.simulate(delta)
	
	var temp: Array[Body]
	for body in bodies:
		if body.is_dead:
			body.queue_free()
		else:
			temp.push_back(body)
	
	bodies = temp
