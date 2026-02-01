extends PuzzlePieceView

@onready var root: Control = $"../../.." as Control
@onready var container_left: VBoxContainer = $"../../../GameplayBox/ScrollContainer/HBoxContainer/LeftContainer"
@onready var container_right: VBoxContainer = $".."
@onready var container_output: VBoxContainer = $"../../../GameplayBox/ScrollContainer/HBoxContainer/OutputContainer"
@onready var placeholder: ColorRect = $"../../../ColorRect" as ColorRect
@onready var threshold_x: float = _get_threshold()

var container: Container
var dragging: bool = false
var offset: Vector2 = Vector2.ZERO

func _process(_delta: float) -> void:
	if dragging:
		var mouse_pos: Vector2 = root.get_local_mouse_position()
		position = mouse_pos + offset
		
		var new_container: Container = container_left if mouse_pos.x < threshold_x else container_right
		
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
	container = get_parent() as Container 
	offset = position - container.get_local_mouse_position()
	
	reparent(root)
	placeholder.reparent(container)
	placeholder.visible = true
	var tmp: NumberBox = container_output.get_child(0)
	placeholder.custom_minimum_size = tmp.size
	placeholder.size_flags_horizontal = SIZE_SHRINK_BEGIN
	
func _stop_drag() -> void:
	dragging = false
	var spot: int = find_spot()
	
	reparent(container)
	if spot != -1:
		container.move_child(self, spot)
		rebalance()
	
	placeholder.visible = false
	placeholder.reparent(root)

func _get_threshold() -> float:
	var left_edge: float = container_left.global_position.x + container_left.size.x
	var right_edge: float = container_right.global_position.x
	return left_edge + ((right_edge - left_edge) / 2.0) + 1000

func find_spot() -> int:
	var mousey: float = container.get_local_mouse_position().y
	var children: Array[Node] = container.get_children()
	
	for i: int in range(children.size()):
		var child: Control = children[i] as Control
		if mousey < child.position.y + child.size.y:
			return i
	return children.size()

func rebalance() -> void:
	var children_left: Array[Node] = container_left.get_children()
	var children_output: Array[Node] = container_output.get_children()
	
	for i: int in range(children_output.size() -1, 0, -1):
		children_output[i].queue_free()
	
	for i: int in range(0, children_left.size()):
		if children_left[i] == placeholder:
			placeholder.visible = false
			placeholder.reparent(root)
			continue
		if children_left[i - 1] == placeholder:
			placeholder.visible = false
			placeholder.reparent(root)
			continue
		var number_box: NumberBox = container_output.get_child(i)
		var puzzle_piece: PuzzlePieceView = children_left[i].get_child(0)
		number_box.do_operation(puzzle_piece.model)
