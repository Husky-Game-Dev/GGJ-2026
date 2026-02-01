extends Control

@onready var root: Control = $"../.." as Control
@onready var container_left: VBoxContainer = $"../../LeftContainer"
@onready var container_right: VBoxContainer = $"../../RightContainer"
@onready var placeholder: ColorRect = root.get_node("ColorRect") as ColorRect
@onready var threshold_x: float = _get_threshold()

var container: VBoxContainer
var dragging: bool = false
var offset: Vector2 = Vector2.ZERO

func _process(_delta: float) -> void:
	if dragging:
		var mouse_pos: Vector2 = root.get_local_mouse_position()
		position = mouse_pos + offset
		
		var new_container: VBoxContainer = container_left if mouse_pos.x < threshold_x else container_right
		
		if new_container != container:
			container = new_container
			placeholder.reparent(container)
		
		var spot: int = find_spot()
		container.move_child(placeholder, spot)

func _gui_input(event: InputEvent) -> void:
	if not dragging and event is InputEventMouseButton:
		var mouse: InputEventMouseButton = event
		if mouse.button_index == MOUSE_BUTTON_LEFT and mouse.pressed:
			_start_drag()

func _input(event: InputEvent) -> void:
	if dragging and event is InputEventMouseButton:
		var mouse: InputEventMouseButton = event
		if mouse.button_index == MOUSE_BUTTON_LEFT and not mouse.pressed:
			_stop_drag()

func _start_drag() -> void:
	dragging = true
	container = get_parent() as VBoxContainer 
	offset = position - container.get_local_mouse_position()
	
	print("parent: ", get_parent())
	reparent(root)
	placeholder.reparent(container)
	placeholder.visible = true
	placeholder.custom_minimum_size = size
	placeholder.size_flags_horizontal = SIZE_SHRINK_BEGIN
	
func _stop_drag() -> void:
	dragging = false
	var spot: int = find_spot()
	
	reparent(container)
	if spot != -1:
		container.move_child(self, spot)
	
	placeholder.visible = false
	placeholder.reparent(root)

func _get_threshold() -> float:
	var left_edge: float = container_left.global_position.x + container_left.size.x
	var right_edge: float = container_right.global_position.x
	return left_edge + ((right_edge - left_edge) / 2.0)

func find_spot() -> int:
	var mousey: float = container.get_local_mouse_position().y
	var children: Array[Node] = container.get_children()
	
	for i: int in range(children.size()):
		var child: Control = children[i] as Control
		if mousey < child.position.y + child.size.y:
			return i
			
	return children.size()
