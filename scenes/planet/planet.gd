extends "res://scenes/body/body.gd"
class_name Planet
	
@export var start_velocity: Vector2 = Vector2(0.0, 0.0)
@export var start_mass: float = 1

@onready var thing = $"Area2D/CollisionShape2D"
@onready var on_screen_notif = $"VisibleOnScreenNotifier2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

	velocity = start_velocity
	set_mass()
#	print(mass)

func set_mass():
	var spriteWidth: float = $"Sprite2D".get_rect().size.x
	scale = Vector2(radius, radius) / (spriteWidth / 2)
	mass = (4.0 / 3.0) * radius * radius * radius * PI * density

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	simulate(delta)
