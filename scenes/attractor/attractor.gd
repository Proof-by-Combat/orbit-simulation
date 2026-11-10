extends CharacterBody2D

class_name Attractor


@export var density: float = 10
var radius: float = 10
var mass: float = 0


func _ready() -> void:
	Simulation.attractors.append(self)
