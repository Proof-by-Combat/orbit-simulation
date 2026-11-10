extends Node

const G: float = 1

var attractors: Array[Attractor]
var attractees: Array[Attractee]

func _physics_process(delta: float) -> void:
	for attractee in attractees:
		attractee.simulate(delta)
	
	# Remove dead objects
	var temp: Array[Attractee]
	for i in attractees:
		if i != null and !i.is_queued_for_deletion():
			temp.append(i)
	
	attractees = temp
