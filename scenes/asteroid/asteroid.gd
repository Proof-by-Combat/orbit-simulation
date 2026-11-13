extends Attractee

class_name Asteroid

#@onready var _sprite: Sprite2D = $"Sprite2D"

func simulate(delta: float) -> void:
	
	super(delta)
