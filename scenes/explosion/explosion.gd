extends GPUParticles2D

class_name Explosion

func _ready() -> void:
	emitting = true

func _on_finished() -> void:
	queue_free()
