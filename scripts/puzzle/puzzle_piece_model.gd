@tool
class_name PuzzlePieceModel extends Resource


enum Operation {
	NONE,
	AND,
	OR,
	XOR,
	LEFT_SHIFT,
	RIGHT_SHIFT,
	NOT,
	OPERATION_MAX
}


## The maximum number of bits that can be displayed. Updates editor inspector and PuzzlePieceView when changed.
const MAX_BITS: int = 16


## The operation this puzzle piece performs. Always set.
@export
var operation: Operation = Operation.NONE:
	set(value):
		operation = value
		notify_property_list_changed()

## A full integer to perform the bitwise operation with. Set on AND, OR, and XOR pieces.
@export
var bitmask: int = 0

## The amount of bits to shift by. Set on LEFT_SHIFT and RIGHT_SHIFT pieces.
@export_range(0, MAX_BITS)
var bits_to_shift: int = 0


func _validate_property(property: Dictionary) -> void:
	if property.name == "bitmask":
		property.hint = PROPERTY_HINT_FLAGS
		property.hint_string = ",".join(range(MAX_BITS).map(func(bit: int) -> String:
			return "0x%X" % (1 << bit)
		))
	
	match operation:
		Operation.AND, Operation.OR, Operation.XOR:
			if property.name == "bitmask":
				property.usage |= PROPERTY_USAGE_EDITOR
			if property.name == "bits_to_shift":
				property.usage &= ~PROPERTY_USAGE_EDITOR
		Operation.LEFT_SHIFT, Operation.RIGHT_SHIFT:
			if property.name == "bitmask":
				property.usage &= ~PROPERTY_USAGE_EDITOR
			if property.name == "bits_to_shift":
				property.usage |= PROPERTY_USAGE_EDITOR
		_:
			if property.name == "bitmask":
				property.usage |= PROPERTY_USAGE_EDITOR
			if property.name == "bits_to_shift":
				property.usage &= ~PROPERTY_USAGE_EDITOR
