class_name PuzzlePieceView extends Button


signal sort_up()
signal sort_down()


@onready
var operation_label: Label = %OperationLabel

@onready
var value_label: Label = %ValueLabel

@onready
var sort_buttons: VBoxContainer = %SortButtons

@onready
var sort_up_button: Button = %SortUpButton

@onready
var sort_down_button: Button = %SortDownButton

@export
var model: PuzzlePieceModel = null

@export
var show_sort_buttons: bool = false

@export
var can_sort_up: bool = true:
	set(value):
		can_sort_up = value
		if is_instance_valid(sort_up_button):
			sort_up_button.disabled = !can_sort_up

@export
var can_sort_down: bool = true:
	set(value):
		can_sort_down = value
		if is_instance_valid(sort_down_button):
			sort_down_button.disabled = !can_sort_down

func _ready() -> void:
	assert(model != null, "PuzzlePieceView was instantiated without a PuzzlePieceModel assigned")
	assert(model.operation != PuzzlePieceModel.Operation.NONE, "PuzzlePieceView was instantiated with a PuzzlePieceModel with an unset operation")
	assert(model.operation < PuzzlePieceModel.Operation.OPERATION_MAX, "PuzzlePieceView was instantiated with a PuzzlePieceModel with an invalid operation")
	
	if show_sort_buttons:
		sort_down_button.disabled = false
		sort_up_button.disabled = false
	else:
		sort_down_button.disabled = true
		sort_up_button.disabled = true
	
	sort_up_button.disabled = !can_sort_up
	sort_down_button.disabled = !can_sort_down
	
	match model.operation:
		PuzzlePieceModel.Operation.AND:
			operation_label.text = "&"
		PuzzlePieceModel.Operation.OR:
			operation_label.text = "|"
		PuzzlePieceModel.Operation.XOR:
			operation_label.text = "^"
		PuzzlePieceModel.Operation.LEFT_SHIFT:
			operation_label.text = "<<"
		PuzzlePieceModel.Operation.RIGHT_SHIFT:
			operation_label.text = ">>"
		PuzzlePieceModel.Operation.NOT:
			operation_label.text = "~"
	match model.operation:
		PuzzlePieceModel.Operation.AND, PuzzlePieceModel.Operation.OR, PuzzlePieceModel.Operation.XOR:
			value_label.text = String.num_uint64(model.bitmask, 2).lpad(PuzzlePieceModel.MAX_BITS, "0")
		PuzzlePieceModel.Operation.LEFT_SHIFT, PuzzlePieceModel.Operation.RIGHT_SHIFT:
			value_label.text = "%d" % model.bits_to_shift
		_:
			value_label.text = ""


func _on_up_button_pressed() -> void:
	sort_up.emit()


func _on_down_button_pressed() -> void:
	sort_down.emit()
