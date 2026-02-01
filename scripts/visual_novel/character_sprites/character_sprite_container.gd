class_name CharacterSpriteContainer
extends Control

@export
var character_sprite_prefab: PackedScene = null

@export
var speaking_color: Color = Color.WHITE

@export
var not_speaking_color: Color = Color.GRAY

var _loaded_sprites: Dictionary[Character, TextureRect]

func load_character(character: Character, offset: Vector2 = Vector2.ZERO) -> void:
	if _loaded_sprites.has(character):
		return
	
	var new_sprite: TextureRect = character_sprite_prefab.instantiate() as TextureRect
	add_child(new_sprite)
	new_sprite.name = character.character_name
	new_sprite.texture = character.full_sprite
	new_sprite.visible = true
	new_sprite.position += offset
	new_sprite.flip_h = character.flipped # flip the character by toggling it in the character .tres
	new_sprite.scale = character.scale
	_loaded_sprites[character] = new_sprite

func remove_character(character: Character) -> void:
	if _loaded_sprites.has(character):
		_loaded_sprites[character].queue_free()
		_loaded_sprites.erase(character)

func set_speaking(speaking_char: Character) -> void:
	for character: Character in _loaded_sprites.keys():
		_loaded_sprites[character].modulate = (speaking_color if character == speaking_char else not_speaking_color)

func clear() -> void:
	for sprite: TextureRect in _loaded_sprites.values():
		sprite.queue_free()
	_loaded_sprites.clear()
