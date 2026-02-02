class_name DialogBox
extends Control

# DialogBox code is based from its implementation in Bubble Sorter, improved for use in Phil Buster.
# TODO:
# - Expose animation for dialog box opening and closing
# - Check if cursor is over other UI elements before emitting _user_interacted signal
# - Rewrite display_string to use variadic arguments once Godot 4.5 is released

##
## Signals
##

# Internal signal to indicate user interaction, which can be used to skip dialog.
signal _user_interacted()

##
## Variables
##

## Icon to display inside the dialog box when an entry is finished.
@export
var finished_icon: Texture2D

## The speed of the dialog box, in characters per second
@export
var talking_speed: float = 25.0

## RichTextLabel to display dialog.
@onready
var _dialog_label: RichTextLabel = %dialog_label

## RichTextLabel to display the character name.
@onready
var _character_name_label: RichTextLabel = %character_name_label

@onready
var _character_logo_label: TextureRect = %character_logo_label

## Container for the character name label, which will be hidden if the name is empty.
@onready
var _character_name_container: Control = %character_name_container

@onready
var _character_logo_container: TextureRect = %character_logo_container

## AudioStreamPlayer which will play with every character
#@onready
#var _sfx_audio_player: AudioStreamPlayer = %sfx_player

## Previous dialog entry, held in case we need to extend it.
var _previous_dialog: String = ""

var _current_input_state: InputManager.InputState = InputManager.InputState.GAMEPLAY

##
## Methods
##

## Sets the character name label to the given name.
func display_character_name(character_logo: Texture2D) -> void:
	# Sets the character name label to the given name and makes it visible
	_character_logo_label.texture = character_logo
	_character_logo_container.visible = true #!character_name.is_empty()

## Displays a list of dialog entries, waiting for user interaction between each entry.
# Variadic version for 4.5: func display_string(...entries: Array) -> void:
func display_string(entries: Array[String]) -> void:
	for entry: String in entries:
		await _display_string(entry)
		await _user_interacted

## Extends a dialog entry with new text.
func extend_string(entries: Array[String], concat_text: String = " ") -> void:
	for entry: String in entries:
		var extended_dialog: String = "%s%s%s" % [_previous_dialog, concat_text, entry]

		await _display_string(extended_dialog, _previous_dialog.length() + concat_text.length())
		await _user_interacted

## Controls whether dialog text is centered or aligned to the top-left.
# Narration text should be centered, while character dialog should be aligned to the top-left.
func set_dialog_centered(centered: bool) -> void:
	if centered:
		_dialog_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_dialog_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	else:
		_dialog_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
		_dialog_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT

## Toggles the visibility of the dialog box.
func set_dialog_visibility(dialog_visibility: bool) -> void:
	if dialog_visibility and not self.visible:

		# TODO: This is useless code that just awaits something so calling members do not receive a warning.
		# Replace with actual animation code later.
		var timer: SceneTreeTimer = get_tree().create_timer(0.1)
		await timer.timeout
		
		self.visible = true
	elif not dialog_visibility and self.visible:
		self.visible = false

# Initially hides the dialog box, skipping any animation.
func _ready() -> void:
	InputManager.input_state_changed.connect(_on_input_state_changed)
	self.visible = false

func _on_input_state_changed(old: InputManager.InputState, new: InputManager.InputState) -> void:
	_current_input_state = new

# Emit our interaction signal if any keyboard or mouse press is detected
func _input(event: InputEvent) -> void:
	var key_valid: bool = event is InputEventMouseButton or event is InputEventKey
	var key_pressed: bool = event.is_pressed()
	var state_valid: bool = _current_input_state == InputManager.InputState.GAMEPLAY
	if key_valid and key_pressed and state_valid:
		_dialog_label.visible_ratio = 1
		_user_interacted.emit()

# Animates one line of text, instantly finishing upon any user interaction
func _display_string(dialog: String, starting_position: int = 0) -> void:
	# Clears dialog label, including the finished icon if it was previously displayed
	_dialog_label.clear()

	var characterDelay: float = 1 / talking_speed 
	
	_previous_dialog = dialog
	_dialog_label.text = dialog
	_dialog_label.visible_characters = starting_position
	
	# We check against visible_ratio because it can be set to 1 by user interaction
	while _dialog_label.visible_ratio < 1:
		# Show the next character and await the character delay timer
		_dialog_label.visible_characters += 1
		
		#if is_instance_valid(_sfx_audio_player):
		#	_sfx_audio_player.play()
		
		var timer: SceneTreeTimer = get_tree().create_timer(characterDelay)
		await timer.timeout
	
	if is_instance_valid(finished_icon):
		_dialog_label.append_text(" ")
		_dialog_label.add_image(finished_icon, _dialog_label.get_theme_font_size("normal_font_size"))
	
	_dialog_label.visible_characters = -1
