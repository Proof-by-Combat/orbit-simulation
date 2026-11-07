extends Node2D

class_name Body

@export var radius: float = 0
@export var density: float = 0

var mass: float = 0
var velocity: float = 0


func _ready() -> void:
	Simulation.bodies.append(self)


func simulate() -> void:
	pass


func _notification(event):
	if (event == NOTIFICATION_PREDELETE):
		Simulation.bodies.erase(self)
