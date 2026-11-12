extends Attractor
class_name Planet

@export var start_velocity: Vector2 = Vector2(0.0, 0.0)

@onready var _sprite: Sprite2D = $"Sprite2D"

@warning_ignore("unused_private_class_variable")
@onready var _on_screen_notif: VisibleOnScreenNotifier2D = $"OnScreen"

@onready var path: PathFollow2D = $"Orbit/PathFollow2D"

func set_mass():
	mass = (4.0 / 3.0) * radius * radius * radius * PI * density


func _ready() -> void:
	super()
	
	var spriteWidth: float = _sprite.get_rect().size.x
	radius = scale.x * spriteWidth / 2
	
	velocity = start_velocity
	set_mass()

func _process(delta: float) -> void:
	if path != null:
		const SPEED: float = .1
		path.progress_ratio += SPEED * delta
