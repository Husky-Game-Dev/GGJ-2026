extends PuzzlePieceView

var container: Container
var dragging: bool = false
var offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Can't do this in the editor for some reason
	(get_child(0) as HBoxContainer).mouse_filter = Control.MOUSE_FILTER_IGNORE
	super._ready()

func _process(_delta: float) -> void:
	if dragging:
		var mouse_pos: Vector2 = Global.active_puzzle.get_local_mouse_position()
		position = mouse_pos + offset
		
		var new_container: Container = Global.active_puzzle.container_left if mouse_pos.x < _get_threshold() else Global.active_puzzle.container_right
		
		if new_container != container:
			container = new_container
			Global.active_puzzle.placeholder.reparent(container)
		
		var spot: int = find_spot()
		container.move_child(Global.active_puzzle.placeholder, spot)

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
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	reparent(Global.active_puzzle)
	Global.active_puzzle.placeholder.reparent(container)
	Global.active_puzzle.placeholder.visible = true
	Global.active_puzzle.placeholder.custom_minimum_size = Vector2(1000, 175)
	Global.active_puzzle.placeholder.size_flags_horizontal = SIZE_SHRINK_BEGIN
	
func _stop_drag() -> void:
	dragging = false
	var spot: int = find_spot()
	mouse_filter = Control.MOUSE_FILTER_STOP
	
	reparent(container)
	
	Global.active_puzzle.placeholder.visible = false
	Global.active_puzzle.placeholder.reparent(Global.active_puzzle)
	
	if spot != -1:
		container.move_child(self, spot)
		if container != Global.active_puzzle.container_left:
			spot = -1
		Global.active_puzzle.rebalance(spot)

func _get_threshold() -> float:
	var right_edge: float = Global.active_puzzle.container_right.global_position.x
	return right_edge

func find_spot() -> int:
	var mousey: float = container.get_local_mouse_position().y
	var children: Array[Node] = container.get_children()
	
	for i: int in range(children.size()):
		var child: Control = children[i] as Control
		if mousey < child.position.y + child.size.y:
			return i
	return children.size()
