class_name NumberBox extends Button


signal sort_up()
signal sort_down()

var number_box_scene: PackedScene = preload("res://scenes/ui/number_box.tscn")
var puzzle_piece_view_scene: PackedScene = preload("res://scenes/ui/puzzle_piece_view.tscn")

@onready
var operation_label: Label = %OperationLabel

@onready
var value_label: Label = %ValueLabel

@export
var model: PuzzlePieceModel = null

func _ready() -> void:
	assert(model != null, "PuzzlePieceView was instantiated without a PuzzlePieceModel assigned")
	assert(model.operation != PuzzlePieceModel.Operation.NONE, "PuzzlePieceView was instantiated with a PuzzlePieceModel with an unset operation")
	assert(model.operation < PuzzlePieceModel.Operation.OPERATION_MAX, "PuzzlePieceView was instantiated with a PuzzlePieceModel with an invalid operation")
	
	value_label.text = String.num_uint64(model.bitmask, 2)
	if (!value_label.text.length() >= PuzzlePieceModel.MAX_BITS):
		value_label.text = ("%0*d" % [PuzzlePieceModel.MAX_BITS - value_label.text.length(),0]) + (String.num_uint64(model.bitmask, 2))

func do_operation(puzzle_piece: PuzzlePieceModel) -> void:
	var puzzle_copy: PuzzlePieceView = puzzle_piece_view_scene.instantiate()
	puzzle_copy.model = puzzle_piece
	puzzle_copy.can_sort_up = true
	puzzle_copy.can_sort_down = true
	puzzle_copy.show_sort_buttons = true
	
	var operation: PuzzlePieceModel.Operation = puzzle_piece.operation
	var amount: int = puzzle_piece.bitmask
	var output: NumberBox = number_box_scene.instantiate()
	output.model = PuzzlePieceModel.new()
	output.model.operation = PuzzlePieceModel.Operation.AND
	match operation:
		PuzzlePieceModel.Operation.AND:
			output.model.bitmask = model.bitmask & amount
		PuzzlePieceModel.Operation.OR:
			output.model.bitmask = model.bitmask | amount
		PuzzlePieceModel.Operation.XOR:
			output.model.bitmask = model.bitmask ^ amount
		PuzzlePieceModel.Operation.LEFT_SHIFT:
			output.model.bitmask = model.bitmask << amount
		PuzzlePieceModel.Operation.RIGHT_SHIFT:
			output.model.bitmask = model.bitmask >> amount
		PuzzlePieceModel.Operation.NOT:
			var tmp_string: String = String.num_uint64(output.model.bitmask, 2)
			for i: int in range(tmp_string.length()):
				var char: String = tmp_string[i]
				if char == "0":
					char = "1"
				else:
					char = "0"
			var curr_value: int = 1
			for char: String in tmp_string:
				if char == "1":
					output.model.bitmask += curr_value
				curr_value *= 2
	output.custom_minimum_size = self.custom_minimum_size
	add_sibling(output)
	add_sibling(puzzle_copy)
