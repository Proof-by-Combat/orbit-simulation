extends Attractee

class_name Asteroid

var _angular_momentum: float = 0
@onready var _sprite: Sprite2D = $"Sprite2D"


func simulate(delta: float) -> void:
	_sprite.global_rotation += _angular_momentum * delta
	super(delta)


func deflect(other_pos: Vector2, other_velocity: Vector2) -> void:
	var normal: Vector2 = (other_pos - global_position)
	var other_direction: Vector2 = other_velocity
	
	normal = normal.normalized()
	other_direction = other_velocity.normalized()
	
	const ROTATION_SCALAR: float = 0.1 # Based on mass?
	var angle1: float = other_direction.angle()
	var angle2: float = normal.angle()
	var difference: float = angle_difference(angle1,angle2)
	var difference_sign: float = sign(difference)
	var graze: float = PI - abs(difference)
	
	var final_rotation: float
	final_rotation = graze * (-difference_sign)
	final_rotation *= ROTATION_SCALAR
	
	_angular_momentum += final_rotation
	
	const VELOCITY_SCALAR: float = 0.05 # Also based on mass?
	velocity += other_velocity * VELOCITY_SCALAR


func _on_hit_zone_area_entered(area: Area2D) -> void:
	if area.owner == null: return
	if !(area.owner is Bullet): return
	
	deflect(area.owner.global_position, area.owner.velocity)
