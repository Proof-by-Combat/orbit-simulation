extends "res://scenes/body/body.gd"

@export var start_velocity: Vector2 = Vector2(0.0, 0.0)
@export var start_mass: float = 1

@onready var thing = $"Area2D/CollisionShape2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	var spriteWidth: float = $"Sprite2D".get_rect().size.x
	velocity = start_velocity
	scale = Vector2(radius, radius) / (spriteWidth / 2)
	mass = (4 / 3) * radius * radius * radius * PI * density
	print(mass)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	simulate(delta)
