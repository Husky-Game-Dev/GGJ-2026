extends VisualNovelScenario

@export
var player: Character
@export
var janitor: Character
@export
var dishwasher: Character
@export
var conclusion_texture: CompressedTexture2D
@export
var scene_texture: CompressedTexture2D
@export
var background: TextureRect

func run_scenario() -> void:
	character_clear_all()
	character_add(player, Vector2(-1500, -1000))
	
	#Dishwasher Conclusion
	character_add(dishwasher, Vector2(850, -400))
	set_background(background, conclusion_texture)
	
	await character_speak(dishwasher, [ "Come here squirrel squirrel squirrel." ])
	await character_speak(dishwasher, [ "Thanks again for all your help! The poor guy never gets a bite to eat out there." ])
	await character_speak(dishwasher, [ "If you wouldn't mind, could you help out the others? the Janitor is just down the hall." ])

	character_remove(dishwasher)
	
	# Janitor Dialogue
	character_add(janitor, Vector2(500, -350))
	set_background(background, scene_texture)
	
	await character_speak(janitor, [ "Hey, you’re the one that delivers stuff right?" ])
	await character_speak(player, [ "That's me!" ])
	await character_speak(janitor, [ "Any chance you could get me a… what's it called… Te-li-vi-son? I’ve always wanted to watch… I think it's called the Ring of the Lords? They’ve been hard to find since humans disappeared." ])
	await character_speak(player, [ "You’re not allowed to watch movies? Let me guess, rule 8 section 42… blah… blah… blah…" ])
	await character_speak(janitor, [ "Close! Rule 8 section 2. If anyone heard about my movies they would never give me a break." ])
	await character_speak(player, [ "I’m sure if they gave it a chance they would love movies just as much as you." ])
