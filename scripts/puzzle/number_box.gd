class_name NumberBox extends Button


signal sort_up()
signal sort_down()

var number_box_scene: PackedScene = preload("res://scenes/ui/number_box.tscn")
var puzzle_piece_view_scene: PackedScene = preload("res://scenes/ui/puzzle_piece_view.tscn")

@onready
var h_box_container: HBoxContainer = %HBoxContainer

@onready
var value_label: Label = %ValueLabel

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

func set_model(new_model: PuzzlePieceModel) -> void:
	if new_model:
		model = new_model
	value_label.text = String.num_uint64(model.bitmask, 2)
	if (!value_label.text.length() >= model.bits):
		value_label.text = ("%0*d" % [model.bits - value_label.text.length(), 0]) + (String.num_uint64(model.bitmask, 2))
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
