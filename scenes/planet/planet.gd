extends "res://scenes/body/body.gd"

@export var start_velocity: Vector2 = Vector2(0.0, 0.0)
@export var start_mass: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	velocity = start_velocity
	mass = start_mass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	simulate(delta)
