extends Camera2D

class_name PlayerCamera

@export var shake_intensity_curve: Curve

var _time: float = 0
var _shake_time: float = 0
var _shake_max_time: float = 0
var _shake_intensity: float = 0


func _do_shake(delta: float) -> void:
	const SHAKE_TIME_SCALE: float = 50
	const SHAKE_INTENSITY_SCALE: float = 0.015
	
	var sample_point: float = 1-(_shake_time / _shake_max_time)
	var curve_sample: float = shake_intensity_curve.sample(sample_point)
	
	var shake_offset := Vector2.ZERO
	shake_offset.x = sin(_time*SHAKE_TIME_SCALE)
	shake_offset.y = sin(_time*SHAKE_TIME_SCALE*0.9)
	shake_offset *= _shake_intensity * SHAKE_INTENSITY_SCALE * curve_sample
	
	offset = shake_offset
	
	_shake_time = move_toward(_shake_time,0,delta)


func _process(delta: float) -> void:
	if _shake_time > 0:
		_do_shake(delta)
	
	_time += delta


# Public function to be called outside of the class
func shake(intensity: float, time: float):
	_shake_time = time
	_shake_max_time = time
	_shake_intensity = intensity
