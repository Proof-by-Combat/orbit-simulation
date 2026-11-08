extends Node

const G: float = 1

var planetThingyMcBob: PackedScene = preload("res://scenes/planet/planet.tscn")
var bodies: Array[Body]
#@onready var planet :Planet = $"../josh_test/Planet"

func _ready() -> void:
	#await get_tree().root.ready
	#spawn_orbital(planet)
	pass
	
	
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


func spawn_orbital(planet:Planet):
	var ref: Planet = planetThingyMcBob.instantiate()
	
	var dir :Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	var dist: float = randf_range(1000, 4000)
	

	ref.position = planet.position + dir * dist
	ref.density = planet.density / 10
	ref.radius = planet.radius / 10
	
	get_tree().root.add_child(ref)
	var acc = ref.get_acceleration()
	ref.velocity = Vector2(-acc.y, acc.x).normalized() * (sqrt((G * planet.mass) / dist) * 1)














func random_stuff_and_things(amount: int):
	await get_tree().root.ready
	for n in range(amount):
		var ref = planetThingyMcBob.instantiate()
		ref.radius = randf_range(10, 50)
		ref.density = randf_range(1, 15)
		ref.position = Vector2(randf_range(-5500, 5500), randf_range(-3000, 3000))
		ref.start_velocity = Vector2(randf_range(-100, 100), randf_range(-100, 100))
		ref.set_mass()
		get_tree().root.add_child(ref)
