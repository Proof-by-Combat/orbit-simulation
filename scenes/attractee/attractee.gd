extends CharacterBody2D

class_name Attractee


var bother_with_collision: bool = false


func _ready() -> void:
	Simulation.attractees.append(self)


func get_acceleration() -> Vector2:
	var acceleration: Vector2 = Vector2(0, 0)
	const cap: float = 500
	
	for attractor in Simulation.attractors:
		var to_attractor: Vector2
		to_attractor = attractor.global_position - global_position
		
		var direction = to_attractor.normalized()
		var distanceSquared = to_attractor.length_squared()
		
		if distanceSquared < 10:
			distanceSquared = 10
		
		var massOverDistance: float = attractor.mass / distanceSquared
		acceleration += massOverDistance * direction * Simulation.G
		
		if acceleration.length() > cap:
			acceleration = acceleration.normalized() * cap
	
	return acceleration


func simulate(delta: float) -> void:
	velocity += get_acceleration() * delta
	
	if bother_with_collision:
		move_and_slide()
	else:
		global_position += velocity * delta
