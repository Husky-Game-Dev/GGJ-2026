extends VisualNovelScenario

@export
var player: Character
@export
var stocker: Character

func run_scenario() -> void:
	character_clear_all()
	character_add(player, Vector2(-1500, -1000))
	character_add(stocker, Vector2(500, -650))
	
	# Stocker Dialogue
	
	await character_speak(stocker, [ "Aah, that's where you are! I’ve been looking for you all… however long its been." ])
	await character_speak(player, [ "Sorry, I couldn’t find the loading bay." ])
	await character_speak(stocker, [ "Hey wait, you're not the usual delivery bot that comes around here." ])
	await character_speak(player, [ "Nope, this is my first day." ])
	await character_speak(stocker, [ "Between you and me, the last delivery bot used to slide me some oil… It's great for my gears!" ])
	await character_speak(stocker, [ "Soooo… Any chance you got some?" ])
	await character_speak(player, [ "Isn’t oil good for bots? Why would you need to get it in secret?" ])
	await character_speak(stocker, [ "Ugh, rule 3 section 2… ‘the consumption of oil is prohibited by all employees.’" ])
	await character_speak(player, [ "This should definitely be changed." ])
