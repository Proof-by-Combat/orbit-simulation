extends CanvasLayer

var _texture: Texture2D = preload("uid://ee48xlx0e6bw")
var _indicators: Array[Sprite2D]


func _process(_delta: float) -> void:
	_indicators = []
	for child in get_children():
		child.queue_free()
	
	var player: Player = PlayerStats.currentPlayer
	if player == null:
		return
	
	if player.camera == null:
		return
	
	var screen_rect: Rect2 = player.get_viewport_rect()
	var screen_size: Vector2 = screen_rect.size
	var center: Vector2 = screen_size / 2.0
	
	for i in Simulation.attractors:
		if not(i is Planet):
			continue
		
		var planet: Planet = i
		
		if planet._on_screen_notif.is_on_screen():
			continue
		
		var to: Vector2 = i.global_position - player.camera.global_position 
		var dist: float = to.length()
		to = to.normalized()
		
		var new_sprite := Sprite2D.new()
		new_sprite.position = center + to * ((screen_size.y / 2.0)-32)
		new_sprite.texture = _texture
		new_sprite.rotation = to.angle()
		new_sprite.offset = Vector2(16,0)
		new_sprite.self_modulate = Color.RED
		
		const MIN_DIST: float = 600
		const MAX_DIST: float = 3000
		new_sprite.scale.x = clamp( (dist-MAX_DIST)/(MIN_DIST-MAX_DIST), 0.2, 8)
		new_sprite.scale.y = new_sprite.scale.x
		
		_indicators.append(new_sprite)
		add_child(new_sprite)
