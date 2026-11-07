extends Node2D

class_name Body

@export var radius: float = 0
@export var density: float = 0

var mass: float = 0
var velocity: Vector2 = Vector2(0, 0)


func _ready() -> void:
	Simulation.bodies.append(self)


func simulate() -> void:
	var acceleration: Vector2 = Vector2(0, 0)
	
	for body in Simulation.bodies:
		if body == self:
			continue
		var distance: Vector2 = body.position - position
		var direction = distance.normalized()
		var distanceSquared = distance * distance
		acceleration += body.mass / distanceSquared * direction * Simulation.G
	
	velocity += acceleration
	position += velocity
	pass


func _notification(event):
	if (event == NOTIFICATION_PREDELETE):
		Simulation.bodies.erase(self)
