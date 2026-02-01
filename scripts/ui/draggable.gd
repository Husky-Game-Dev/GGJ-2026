extends Control

@onready var root: Control = $"../../.." as Control
@onready var container_left: GridContainer = $"../../../GameplayBox/ScrollContainer/LeftContainer"
@onready var container_right: VBoxContainer = $".."
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
		
		if container == container_left:
			var columns: int = container_left.columns
			if i % columns == 0:
				continue
		if mousey < child.position.y + child.size.y:
			return i
	return children.size()

func rebalance() -> void:
	var children: Array[Node] = container_left.get_children()
	for i: int in range(children.size() -1, 0, -1):
		if children[i] is NumberBox:
			children[i].queue_free()
	
	for i: int in range(0, children.size() / 2, 2):
		if container_left.get_child(i + 1) is NumberBox:
			container_left.get_child(i + 1).queue_free()
			return
		if container_left.get_child(i + 1) == placeholder:
			placeholder.visible = false
			placeholder.reparent(root)
		var number_box: NumberBox = container_left.get_child(i)
		var puzzle_piece: PuzzlePieceView = container_left.get_child(i + 1).get_child(0)
		var result: NumberBox = number_box.do_operation(puzzle_piece.model)
		container_left.add_child(result)
		container_left.move_child(result, i + 2)
