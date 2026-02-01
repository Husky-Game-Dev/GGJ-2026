extends VisualNovelScenario

@export
var player: Character
@export
var janitor: Character

# DEBUG CODE TO AUTOMATICALLY START OUR SCENARIO
# THIS SHOULD BE HANDLED BY THE MAIN GAME LOOP
func _ready() -> void:
	run_scenario()

func run_scenario() -> void:
	character_add(player, Vector2(-1500, -1000))
	character_add(janitor, Vector2(500, -350))
	
	# Janitor Dialogue
	
	await character_speak(janitor, [ "Hey, you’re the one that delivers stuff right?" ])
	await character_speak(player, [ "That's me!" ])
	await character_speak(janitor, [ "Any chance you could get me a… what's it called… Te-li-vi-son? I’ve always wanted to watch… I think it's called the Ring of the Lords? They’ve been hard to find since humans disappeared." ])
	await character_speak(player, [ "You’re not allowed to watch movies? Let me guess, rule 8 section 42… blah… blah… blah…" ])
	await character_speak(janitor, [ "Close! Rule 8 section 2. If anyone heard about my movies they would never give me a break." ])
	await character_speak(player, [ "I’m sure if they gave it a chance they would love movies just as much as you." ])
