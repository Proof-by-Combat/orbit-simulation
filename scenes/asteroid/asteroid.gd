extends Attractee

# TODO: Sometimes, it doesn't register that bullets hit (even tho it kills it)
# TODO: Player shouldn't die by hitting a hazard moving away from them.
class_name Asteroid

var _angular_momentum: float = 0
var _last_hit_angle: float = 0
@onready var _sprite: Sprite2D = $"Sprite2D"

const NUMBER_OF_OFFSPRING: int = 4
const MAX_GENERATIONS: int = 3
var generation: int = 0

var max_health: float = 100
@onready var health: float = max_health

@onready var _explosion_scene: PackedScene = preload("uid://dcmp5jpyb5o1a")
@onready var _asteroid_scene: PackedScene = preload("uid://78mw0o6fxyto")


func simulate(delta: float) -> void:
	_sprite.global_rotation += _angular_momentum * delta
	super(delta)
	
	if health <= 0:
		_explode_and_die()


func _split() -> void:
	const AWAY_FORCE: float = 100
	var away_distance: float = (_sprite.get_rect().size.x/4)
	away_distance *= global_scale.x
	var angle_offset: float = _last_hit_angle + (PI/2)
	
	for i in range(NUMBER_OF_OFFSPRING):
		var away_angle: float = (TAU / NUMBER_OF_OFFSPRING) * i
		away_angle += angle_offset
		
		var away := Vector2(cos(away_angle), sin(away_angle))
		var away_normalized: Vector2 = away
		away *= away_distance
		
		var offspring: Asteroid = _asteroid_scene.instantiate()
		offspring.global_position = global_position + away
		offspring.global_scale = global_scale / 2
		offspring.velocity = velocity + (away_normalized * AWAY_FORCE)
		offspring.generation = generation + 1
		offspring.max_health = max_health / 2
		
		add_sibling(offspring)


func _explode_and_die() -> void:
	for i in range(5):
		var half_size: Vector2 = _sprite.get_rect().size / 2
		half_size *= global_scale
		
		var explosion: OneShotParticle = _explosion_scene.instantiate()
		explosion.global_position = global_position
		explosion.global_position.x += randf_range(-half_size.x,half_size.x)
		explosion.global_position.y += randf_range(-half_size.y,half_size.y)
		explosion.scale = global_scale
		explosion.z_index = z_index + 10
		add_sibling(explosion)
	
	if generation < 2:
		_split()
	
	queue_free()


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
	
	_last_hit_angle = angle1
	
	var final_rotation: float
	final_rotation = graze * (-difference_sign)
	final_rotation *= ROTATION_SCALAR
	
	_angular_momentum += final_rotation
	
	const VELOCITY_SCALAR: float = 0.05 # Also based on mass?
	velocity += other_velocity * VELOCITY_SCALAR


func _on_hit_zone_area_entered(area: Area2D) -> void:
	if area.owner == null: return
	
	if (area.owner is Bullet):
		health -= area.owner.damage
		deflect(area.owner.global_position, area.owner.velocity)
		print(health)
