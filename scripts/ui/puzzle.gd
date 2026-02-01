class_name Puzzle
extends Control

signal puzzle_complete

@onready
var placeholder: ColorRect = %Placeholder

@onready
var output: BoxContainer = %OutputContainer

@onready
var scroll: ScrollContainer = %ScrollContainer

@onready
var enemy_sprite: Sprite2D = %EnemySprite

@onready
var button: Button = %WinButton

@export
var levels: Array[Level] = []

var loaded_level: int = -1

@export
var starts: Array[NumberBox] = []

@export
var ends: Array[NumberBox] = []

@export
var containers: Array[BoxContainer] = []

@export
var container_left: VBoxContainer = null

@export
var container_right: VBoxContainer = null

@export
var container_output: VBoxContainer = null

@onready
var _music_player: AudioStreamPlayer = $PuzzleMusic

var piece_scn: PackedScene = preload("res://scenes/ui/puzzle_piece_view.tscn")

var _original_enemy_sprite_pos: Vector2 = Vector2.ZERO

var no_win_button: bool = false

func _ready() -> void:
	_original_enemy_sprite_pos = enemy_sprite.position
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed() -> void:
	_music_player.playing = visible

func load_level(level: int) -> void:
	if level < 0 or level >= levels.size():
		print("Attempted to load invalid level")
		loaded_level = -1
		return
	else:
		print("Loading level ", level)
		loaded_level = level
	Global.active_puzzle = self
	for start: NumberBox in starts:
		start.set_model(levels[level].starting_number)
	for end: NumberBox in ends:
		end.set_model(levels[level].target_number)
	
	for container: BoxContainer in containers:
		for child: Control in container.get_children():
			child.queue_free()
	for model: PuzzlePieceModel in levels[level].operations:
		var piece: PuzzlePieceView = piece_scn.instantiate()
		piece.model = model
		containers[1].add_child(piece)
	
	enemy_sprite.texture = levels[level].enemy.mini_sprite
	if levels[level].enemy.character_name == "The Chef":
		# The chef's sprite is larger and needs a hardcoded position
		enemy_sprite.position = Vector2(176.0, -744)
	else:
		enemy_sprite.position = _original_enemy_sprite_pos
	
	if output.get_child(1) != null:
		output.get_child(1).queue_free()
	var last_output: NumberBox = output.get_child(output.get_children().size() - 1) as NumberBox
	last_output.modulate = Color(1, 1, 1, 1)
	var end: NumberBox = %End
	end.modulate = Color(1, 1, 1, 1)
	visible = true
	no_win_button = false

func _process(delta: float) -> void:
	var children_output: Array[Node] = output.get_children()
	var last_output: NumberBox = children_output[children_output.size() - 1] as NumberBox
	if last_output.model.bitmask == ends[0].model.bitmask:
		last_output.modulate = Color(0.85, 0.00, 0.22, 1.00)
		var end: NumberBox = %End
		end.modulate = Color(0.85, 0.00, 0.22, 1.00)
		if !no_win_button:
			button.visible = true
	else:
		last_output.modulate = Color(1, 1, 1, 1)
		var end: NumberBox = %End
		end.modulate = Color(1, 1, 1, 1)
		button.visible = false

func rebalance(spot: int) -> void:
	var children_left: Array[Node] = containers[0].get_children()
	var children_output: Array[Node] = output.get_children()
	
	for i: int in range(children_output.size() -1, 0, -1):
		children_output[i].queue_free()
	
	for i: int in range(0, children_left.size()):
		if children_left[i] is not PuzzlePieceView:
			(children_left[i] as Control).visible = false
			children_left[i].reparent(self)
			continue
		var number_box: NumberBox = output.get_child(i)
		var puzzle_piece: PuzzlePieceView = children_left[i]
		number_box.do_operation(puzzle_piece.model)
	var last_output: NumberBox = children_output[children_output.size() - 1]
	
	await get_tree().create_timer(0).timeout
	children_output = output.get_children()
	if spot+1 < children_output.size():
		spot += 1
	var new_output: NumberBox = output.get_child(spot) as NumberBox
	# FIXME: This crashes if you drop a puzzle piece on the right side at an index higher than there are puzzle pieces on the left side
	#(output.get_child(spot) as NumberBox).grab_focus(true)


func _on_win_button_pressed() -> void:
	button.visible = false
	no_win_button = true
	puzzle_complete.emit()
