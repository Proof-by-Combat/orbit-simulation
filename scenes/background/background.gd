extends Polygon2D

@export var camera: Camera2D
@export var looped_texture: Texture2D
@export var parallax_amount: float = 0.5

func _ready() -> void:
	texture = looped_texture
	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED


func _process(_delta: float) -> void:
	if camera == null:
		push_error("Background cannot find a Camera2D.")
		return
	
	var rect: Rect2
	var screen_rect: Rect2 = get_viewport_rect()
	rect.size = screen_rect.size / camera.zoom
	rect.position = camera.get_screen_center_position() - (rect.size/2)
	
	var new_polygon: PackedVector2Array = []
	new_polygon.append(rect.position)
	new_polygon.append(rect.position + Vector2(rect.size.x,0))
	new_polygon.append(rect.position + rect.size)
	new_polygon.append(rect.position + Vector2(0,rect.size.y))
	
	rect.position *= parallax_amount
	rect.position -= ((rect.size/2) * (1-parallax_amount))
	
	var new_uvs: PackedVector2Array = []
	new_uvs.append(rect.position)
	new_uvs.append(rect.position + Vector2(rect.size.x,0))
	new_uvs.append(rect.position + rect.size)
	new_uvs.append(rect.position + Vector2(0,rect.size.y))
	
	polygon = new_polygon
	uv = new_uvs
	
	if camera != null:
		self_modulate.a = camera.zoom.x * 3
