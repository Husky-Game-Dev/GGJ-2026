# Character data model to use between Visual Novel and Puzzle scenes
class_name Character
extends Resource

@export
var character_name: String = "New Character"

@export
var full_sprite: Texture2D = null

@export
var mini_sprite: Texture2D = null

@export
var logo: Texture2D = null

@export
var flipped: bool = false

@export
var scale: Vector2 = Vector2(1, 1)

@export
var position: Vector2 = Vector2(0, 0)
