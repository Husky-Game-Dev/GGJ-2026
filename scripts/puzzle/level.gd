# Puzzle level data
class_name Level
extends Resource

# Must be Operation.NONE
@export
var starting_number: PuzzlePieceModel
@export
var target_number: PuzzlePieceModel

@export
var operations: Array[PuzzlePieceModel] = []

@export
var enemy: Character
