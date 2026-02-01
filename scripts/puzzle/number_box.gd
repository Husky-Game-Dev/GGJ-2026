extends Button


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
	
	value_label.text = String.num_uint64(model.bitmask, 2)
	if (!value_label.text.length() >= PuzzlePieceModel.MAX_BITS):
		value_label.text = ("%0*d" % [PuzzlePieceModel.MAX_BITS - value_label.text.length(),0]) + (String.num_uint64(model.bitmask, 2))
