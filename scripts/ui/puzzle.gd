class_name Puzzle
extends Control

@export var levels: Array[Level] = []

@onready var starts: Array[NumberBox] = [$StartToEnd/Start, $GameplayBox/ScrollContainer/HBoxContainer/OutputContainer/Start]
@onready var ends: Array[NumberBox] = [$StartToEnd/End, $GameplayBox/End]
@onready var containers: Array[BoxContainer] = [$GameplayBox/ScrollContainer/HBoxContainer/LeftContainer, $PuzzleBox2/RightContainer]
@onready var output: BoxContainer = $GameplayBox/ScrollContainer/HBoxContainer/OutputContainer

var piece_scn: PackedScene = preload("res://scenes/ui/puzzle_piece_view.tscn")

func _ready() -> void:
	_load_level(1)

func _load_level(level: int) -> void:
	if level < 0 or level >= levels.size():
		print("Attempted to load invalid level")
		return
	else:
		print("Loading level ", level)
	for start: NumberBox in starts:
		start.set_model(levels[level].starting_number)
	for end: NumberBox in ends:
		end.set_model(levels[level].target_number)
	
	for container: BoxContainer in containers:
		for child: Control in container.get_children():
			child.queue_free()
	for model: PuzzlePieceModel in levels[level].operations:
		var piece: PuzzlePieceView = piece_scn.instantiate()
		piece.model = model
		containers[1].add_child(piece)
	
	visible = true

func rebalance() -> void:
	var children_left: Array[Node] = containers[0].get_children()
	var children_output: Array[Node] = output.get_children()
	
	for i: int in range(children_output.size() -1, 0, -1):
		children_output[i].queue_free()
	
	for i: int in range(0, children_left.size()):
		if children_left[i] is not PuzzlePieceView:
			(children_left[i] as Control).visible = false
			children_left[i].reparent(self)
			continue
		var number_box: NumberBox = output.get_child(i)
		var puzzle_piece: PuzzlePieceView = children_left[i]
		number_box.do_operation(puzzle_piece.model)
	var last_output: NumberBox = children_output[children_output.size() - 1]
	#if last_output.model.bitmask == end[0].model.bitmask:
		#print("win")
