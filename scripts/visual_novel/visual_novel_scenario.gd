@abstract
class_name VisualNovelScenario
extends Control

# TODO:
# - Character resource which holds name, portraits, emotions, and other metadata
# - Portrait display and management
# - Scene background display and management
# - Music and sound effect management
# - Choices and branching dialog(??)
# - Test extending scenarios off of base class
# - Perhaps consider a reading log system so players can review past dialog
# - Switch to using variadic arguments for dialog once Godot 4.5 is released

###
### Variables
###

@onready
var _dialog_box: DialogBox = %dialog_box

@onready
var _character_sprite_container: CharacterSpriteContainer = %character_sprite_container

@onready
var _music_player: AudioStreamPlayer = %music_player

###
### Methods
###

# Main method that will handle execution of the Visual Novel scenario.
# _ready() should only be kept for initialization.
@abstract
func run_scenario() -> void

### Character functions
func character_add(character: Character, offset: Vector2 = Vector2.ZERO) -> void:
	_character_sprite_container.load_character(character, offset)

func character_speak(character: Character, dialog: Array[String]) -> void:
	_character_sprite_container.set_speaking(character)
	await speak(character.logo, dialog)

func character_remove(character: Character) -> void:
	_character_sprite_container.remove_character(character)

func character_clear_all() -> void:
	_character_sprite_container.clear()
	
func set_background(background: TextureRect, image: CompressedTexture2D) -> void:
	background.texture = image

### Dialog box functions
func show_dialog_box() -> void:
	await _dialog_box.set_dialog_visibility(true)

func hide_dialog_box() -> void:
	await _dialog_box.set_dialog_visibility(false)

# GDScript does not and will not support method overloading. This is not ideal.
func narrate(dialog: Array[String]) -> void:
	# Ensure all lines are italicized
	for i: int in range(dialog.size()):
		var line: String = dialog[i]
	
		if not line.begins_with("[i]"):
			line = "[i]%s[/i]" % line
			dialog[i] = line

	#_dialog_box.display_character_name("")
	_dialog_box.set_dialog_centered(true)
	_dialog_box._character_logo_container.visible = false
	await _dialog_box.set_dialog_visibility(true)
	await _dialog_box.display_string(dialog)

func speak(character_name: Texture2D, dialog: Array[String]) -> void:
	_dialog_box.display_character_name(character_name)
	_dialog_box.set_dialog_centered(false)		
	await _dialog_box.set_dialog_visibility(true)
	await _dialog_box.display_string(dialog)

func extend(dialog: Array[String]) -> void:
	await _dialog_box.set_dialog_visibility(true)
	await _dialog_box.extend_string(dialog)

### Music
func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed() -> void:
	_music_player.playing = visible
