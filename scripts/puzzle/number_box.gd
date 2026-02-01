class_name NumberBox extends Button


signal sort_up()
signal sort_down()

var number_box_scene: PackedScene = preload("res://scenes/ui/number_box.tscn")
var puzzle_piece_view_scene: PackedScene = preload("res://scenes/ui/puzzle_piece_view.tscn")

@onready
var value_label: Label = %ValueLabel

@export
var model: PuzzlePieceModel = null

func _ready() -> void:
	assert(model != null, "PuzzlePieceView was instantiated without a PuzzlePieceModel assigned")
	set_model(model)

func set_model(new_model: PuzzlePieceModel) -> void:
	if new_model:
		model = new_model
	value_label.text = String.num_uint64(model.bitmask, 2)
	if (!value_label.text.length() >= PuzzlePieceModel.MAX_BITS):
		value_label.text = ("%0*d" % [PuzzlePieceModel.MAX_BITS - value_label.text.length(),0]) + (String.num_uint64(model.bitmask, 2))

func do_operation(puzzle_piece: PuzzlePieceModel) -> void:
	var bitmask: int = (1 << PuzzlePieceModel.MAX_BITS) - 1
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
			output.model.bitmask = model.bitmask << puzzle_piece.bits_to_shift
		PuzzlePieceModel.Operation.RIGHT_SHIFT:
			output.model.bitmask = model.bitmask >> puzzle_piece.bits_to_shift
		PuzzlePieceModel.Operation.NOT:
			# Construct a temporary mask that is all the bits we care about
			# We further OR (bits - 1) to include all possible bits beneath it
			#var not_mask: int = PuzzlePieceModel.MAX_BITS
			#not_mask |= PuzzlePieceModel.MAX_BITS - 1
			
			output.model.bitmask = model.bitmask ^ 65535
			
			# Perform bitwise NOT, then AND it with the bits we care about
			# This should leave our desired bits inverted, while the rest of the integer remains untouched
			#output.model.bitmask = ~model.bitmask
			#output.model.bitmask &= not_mask
	output.model.bitmask &= bitmask
	output.custom_minimum_size = self.custom_minimum_size
	add_sibling(output)
