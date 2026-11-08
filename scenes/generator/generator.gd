extends Node2D

class_name Generator

@export var number_of_planets: int = 10
@export var radius_minimum: float = 10
@export var radius_maximum: float = 100
@export var density_minimum: float = 10
@export var density_maximum: float = 100
@export var spawn_range: float = 2500
@export var safe_range: float = 500

var _planet_scene: PackedScene = preload("uid://b2qdeac1q7lwp")


func _ready() -> void:
	await get_tree().root.ready
	
	for i in range(number_of_planets):
		var distance: float = randf_range(safe_range, spawn_range)
		var angle: float = randf_range(0,TAU)
		var pos := Vector2( cos(angle)*distance, sin(angle)*distance )
		
		var radius = randf_range(radius_minimum, radius_maximum)
		var density = randf_range(density_minimum, density_maximum)
		
		var ref: Planet = _planet_scene.instantiate()
		ref.global_position = pos
		ref.radius = radius
		ref.density = density
		ref.call_deferred("set_mass")
		
		add_sibling(ref)
