extends VisualNovelScenario

@export
var player: Character
@export
var waiter_unmasked: Character
@export
var dining_room: CompressedTexture2D
@export
var background: TextureRect

func run_scenario() -> void:
	set_background(background, dining_room)
	
	character_add(player, Vector2(-1500, -1000))
	character_add(waiter_unmasked, Vector2(1000, -950))

	# Waiter Conclusion Dialogue
	await character_speak(waiter_unmasked, [ "I can't believe I have been fooled all this time..." ])
	await character_speak(waiter_unmasked, [ "We've been serving an empty crowd for far too long" ])
	await character_speak(waiter_unmasked, [ "The show must not go on..." ])
	
	character_remove(waiter_unmasked)
	await narrate([ "Congratulation Delivery Guy! You have successfully unveiled the mask that unfaithful rulings create. Go forth, and tell the rest of robo-kind." ])
	await narrate([ "The End." ])
