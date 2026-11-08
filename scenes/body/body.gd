extends Node2D

class_name Body

@export var radius: float = 0
@export var density: float = 0

var mass: float = 0
var velocity: Vector2 = Vector2(0, 0)

var is_dead: bool = false

func _ready() -> void:
	Simulation.bodies.append(self)


func simulate(delta: float) -> void:
	
	var acceleration: Vector2 = Vector2(0, 0)
	
	for body in Simulation.bodies:
		if is_dead or body == self or body.is_dead:
			continue
		var raw_distance: Vector2 =  body.position - position 
		var direction = raw_distance.normalized()
		var distanceSquared = raw_distance.length_squared()
		if distanceSquared < 10:
			distanceSquared = 10
		acceleration += (body.mass / distanceSquared) * direction * Simulation.G
	
#	print(self.name)
#	print('\t', "Pos:", position)
#	print('\t', "Vel:", velocity)
#	print('\t', "Acc: ", acceleration)

	velocity += acceleration * delta
	global_position += velocity * delta
