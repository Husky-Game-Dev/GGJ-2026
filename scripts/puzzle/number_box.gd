class_name NumberBox extends Button


signal sort_up()
signal sort_down()

var number_box_scene: PackedScene = preload("res://scenes/ui/number_box.tscn")

@onready
var h_box_container: HBoxContainer = %HBoxContainer

@onready
var value_label: RichTextLabel = %ValueLabel

@export
var model: PuzzlePieceModel = null

@export var center: bool = false

var _original_offset_left: float = 0.0
var _original_offset_right: float = 0.0

func _ready() -> void:
	assert(model != null, "PuzzlePieceView was instantiated without a PuzzlePieceModel assigned")
	_original_offset_left = h_box_container.offset_left
	_original_offset_right = h_box_container.offset_right
	set_model(model)

static func bitmask_to_string(model: PuzzlePieceModel) -> String:
	var digits: String
	digits = String.num_uint64(model.bitmask, 2)
	if (!digits.length() >= model.bits):
		digits = ("%0*d" % [model.bits - digits.length(), 0]) + (String.num_uint64(model.bitmask, 2))
	return digits

func set_model(new_model: PuzzlePieceModel) -> void:
	if new_model:
		model = new_model
	var digits: String = bitmask_to_string(model)
	var colored_digits: String = ""
	
	if digits.length() == Puzzle.target.length():
		for i: int in range(digits.length()):
			var char1: String = digits[i]
			var char2: String = Puzzle.target[i]
			if char1 == char2:
				colored_digits += "[color=green]%s[/color]" % char1
			else:
				colored_digits += "[color=red]%s[/color]" % char1
		value_label.text = colored_digits
	else:
		value_label.text = digits
	
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER if center else HORIZONTAL_ALIGNMENT_RIGHT
	h_box_container.offset_left = 0.0 if center else _original_offset_left
	h_box_container.offset_right = 0.0 if center else _original_offset_right

func do_operation(puzzle_piece: PuzzlePieceModel) -> void:
	var operation: PuzzlePieceModel.Operation = puzzle_piece.operation
	var amount: int = puzzle_piece.bitmask
	var output: NumberBox = number_box_scene.instantiate()
	output.model = PuzzlePieceModel.new()
	output.model.bits = puzzle_piece.bits
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
			output.model.bitmask = ~model.bitmask
	output.model.bitmask &= (1 << output.model.bits) - 1
	output.custom_minimum_size = self.custom_minimum_size
	add_sibling(output)
