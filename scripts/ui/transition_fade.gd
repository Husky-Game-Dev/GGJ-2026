extends Control
class_name TransitionFade

@export
var _transition_duration: float = 0.5

@onready
var _rect: ColorRect = $ColorRect

var _main_bus_idx: int
var _cached_main_bus_volume: float

func _ready() -> void:
	_main_bus_idx = AudioServer.get_bus_index("Master")
	_cached_main_bus_volume = AudioServer.get_bus_volume_linear(_main_bus_idx)

func fade_in_transition() -> void:
	_cached_main_bus_volume = AudioServer.get_bus_volume_linear(_main_bus_idx)
	print("Cached volume is %d" % _cached_main_bus_volume)
	
	var tween: Tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(_rect, "color", Color(0, 0, 0, 1), _transition_duration)
	tween.tween_method(_fade_audio, 1, 0, _transition_duration)
	tween.play()
	
	await tween.finished

func fade_out_transition() -> void:
	var tween: Tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(_rect, "color", Color(0, 0, 0, 0), _transition_duration)
	tween.tween_method(_fade_audio, 0, 1, _transition_duration)
	tween.play()
	
	await tween.finished

func _fade_audio(mul: float) -> void:
	var main_bus_volume: float = _cached_main_bus_volume * mul
	AudioServer.set_bus_volume_linear(_main_bus_idx, main_bus_volume)
