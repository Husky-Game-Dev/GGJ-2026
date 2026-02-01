extends Control

@onready var container: VBoxContainer = $".."
@onready var root: Control = container.get_parent()
@onready var placeholder: ColorRect = root.get_node("ColorRect")

var dragging: bool = false
var offset: Vector2

func _process(delta: float) -> void:
	if dragging:
		position = root.get_local_mouse_position() + offset
		container.move_child(placeholder, find_spot())

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse : InputEventMouseButton = event
		if mouse.button_index == MOUSE_BUTTON_LEFT and mouse.pressed:
			_start_drag()

func _input(event: InputEvent) -> void:
	if dragging and event is InputEventMouseButton:
		var mouse : InputEventMouseButton = event
		if mouse.button_index == MOUSE_BUTTON_LEFT and mouse.is_released():
			_stop_drag()

func _start_drag() -> void:
	dragging = true
	reparent(container.get_parent())
	offset = position - root.get_local_mouse_position()
	placeholder.reparent(container)
	placeholder.visible = true
	placeholder.custom_minimum_size = size
	
func _stop_drag() -> void:
	dragging = false
	var spot: int = find_spot()
	reparent(container)
	if spot != -1 and spot < container.get_child_count():
		container.move_child(self, spot)
	placeholder.reparent(container.get_parent())
	placeholder.visible = false

func find_spot() -> int:
	var last_height: int = 0
	var height: int = 0
	var mousey: float = container.get_local_mouse_position().y
	for i: int in container.get_child_count():
		if container.get_child(i) == placeholder:
			mousey -= placeholder.size.y / 2
		last_height = height
		height = (container.get_child(i) as Control).position.y
		if mousey > last_height and mousey < height:
			if mousey - last_height < height - mousey:
				return i-1
			else:
				return i
		elif mousey <= last_height:
			return i
	return -1
