extends CharacterBody2D

class_name Attractor



@export var density: float = 0:
	set = _set_density
@export var radius: float = 1:
	set = _set_radius
@export var mass: float = 0:
	set = _set_mass


func _ready() -> void:
	Simulation.attractors.append(self)

func _set_density(value: float):
	density = value

func _set_mass(value: float):
	mass = value

func _set_radius(value: float):
	radius = value
