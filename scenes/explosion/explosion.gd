extends AnimatedSprite2D

class_name Explosion

func _ready() -> void:
	play("Explode")
	animation_finished.connect(_die)

func _die() -> void:
	queue_free()
