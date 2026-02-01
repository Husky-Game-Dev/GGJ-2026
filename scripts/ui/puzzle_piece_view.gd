class_name PuzzlePieceView extends Button


signal sort_up()
signal sort_down()


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
	
	match model.operation:
		PuzzlePieceModel.Operation.AND:
			operation_label.text = "& "
		PuzzlePieceModel.Operation.OR:
			operation_label.text = "| "
		PuzzlePieceModel.Operation.XOR:
			operation_label.text = "^ "
		PuzzlePieceModel.Operation.LEFT_SHIFT:
			operation_label.text = "<<"
		PuzzlePieceModel.Operation.RIGHT_SHIFT:
			operation_label.text = ">>"
		PuzzlePieceModel.Operation.NOT:
			operation_label.text = "~ "
	match model.operation:
		PuzzlePieceModel.Operation.AND, PuzzlePieceModel.Operation.OR, PuzzlePieceModel.Operation.XOR:
			value_label.text = String.num_uint64(model.bitmask, 2).lpad(PuzzlePieceModel.MAX_BITS, "0")
		PuzzlePieceModel.Operation.LEFT_SHIFT, PuzzlePieceModel.Operation.RIGHT_SHIFT:
			value_label.text = "%d" % model.bits_to_shift
		_:
			value_label.text = ""
