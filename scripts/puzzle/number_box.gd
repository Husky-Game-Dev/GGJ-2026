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
			var not_mask: int = 0
			for i: int in range(64):
				var check_mask: int = 1 << i
				# If this bit is set, our NOT mask should set this bit
				# and every bit behind us
				if (model.bitmask & check_mask) != 0:
					not_mask |= check_mask
					not_mask |= check_mask - 1
			# Our NOT mask should now have all bits that actually have a number
			output.model.bitmask = ~model.bitmask
			output.model.bitmask &= not_mask
	output.custom_minimum_size = self.custom_minimum_size
	add_sibling(output)
