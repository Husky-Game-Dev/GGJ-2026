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
			operation_label.text = "&"
			tooltip_text = "AND operator \n
				Sets bit to 1 if both bits are 1, set bit to 0 otherwise. \n
				1001 & 1010 \n
				1000"
		PuzzlePieceModel.Operation.OR:
			operation_label.text = "|"
			tooltip_text = "OR operator\n
				Sets bit to 1 if one of the bits are 1, set bit to 0 otherwise. \n
				1001 | 1010 \n
				1011"
		PuzzlePieceModel.Operation.XOR:
			operation_label.text = "^"
			tooltip_text = "XOR operator\n
				Sets bit to 1 if both bits are different, set bit to 0 otherwise. \n
				1001 & 1010 \n
				0011"
		PuzzlePieceModel.Operation.LEFT_SHIFT:
			operation_label.text = "<<"
			tooltip_text = "L Shift operator\n
				Move existing numbers to the left, 0 takes place of bits that was not in original number \n
				1001 << 2 \n
				0100"
		PuzzlePieceModel.Operation.RIGHT_SHIFT:
			operation_label.text = ">>"
			tooltip_text = "R Shift operator\n
				Move existing numbers to the right, 0 takes place of bits that was not in original number \n
				1001 >> 2 \n
				0010"
		PuzzlePieceModel.Operation.NOT:
			operation_label.text = "~"
			tooltip_text = "NOT operator\n
				Invert all bits, change 1 to 0 and 0 to 1 \n
				1001 ~ \n
				0110"
	match model.operation:
		PuzzlePieceModel.Operation.AND, PuzzlePieceModel.Operation.OR, PuzzlePieceModel.Operation.XOR:
			value_label.text = String.num_uint64(model.bitmask, 2).lpad(model.bits, "0")
		PuzzlePieceModel.Operation.LEFT_SHIFT, PuzzlePieceModel.Operation.RIGHT_SHIFT:
			value_label.text = "%d" % model.bits_to_shift
		_:
			value_label.text = ""
