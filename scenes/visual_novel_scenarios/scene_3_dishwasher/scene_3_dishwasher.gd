extends VisualNovelScenario

@export
var player: Character
@export
var dishwasher: Character
@export
var stocker: Character


# DEBUG CODE TO AUTOMATICALLY START OUR SCENARIO
# THIS SHOULD BE HANDLED BY THE MAIN GAME LOOP
func _ready() -> void:
	run_scenario()

func run_scenario() -> void:
	character_add(player, Vector2(-1500, -1000))
	
	#Stocker Conclusion
	character_add(stocker, Vector2(500, -650))
	
	await character_speak(stocker, [ "Thats right. Oil is good for me. Why should I be ashamed to have a treat every once an a while?" ])
	await character_speak(player, [ "Thats the spirit!" ])
	await character_speak(stocker, [ "Hey, could you help out the Dishwasher? I wouldn't mind a drinking buddy." ])

	character_remove(stocker)
	
	# Dishwasher Dialogue
	character_add(dishwasher, Vector2(850, -400))
	
	await character_speak(dishwasher, [ "Hey, you come from the outside don’t you? What's it like out there?" ])
	await character_speak(player, [ "You’ve never seen it?" ])
	await character_speak(dishwasher, [ "Only what I can see from the trash bins…" ])
	await character_speak(dishwasher, [ "Sometimes a squirrel walks up to me because of the smell of the leftovers… How I wish that I could feed it… It looks sooo hungry." ])
	await character_speak(player, [ "Why don’t you? You're just going to throw out the food anyway." ])
	await character_speak(dishwasher, [ "Rule 2 section 1 tells us that all food waste must go to the trash bins. If I were to feed the starving squirrels, my coworkers would never let me live it down." ])
	await character_speak(player, [ "That's crazy, I’m sure they would understand." ])

	
	



	
	
	
