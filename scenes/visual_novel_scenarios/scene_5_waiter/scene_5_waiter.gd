extends VisualNovelScenario

@export
var player: Character
@export
var waiter: Character

# DEBUG CODE TO AUTOMATICALLY START OUR SCENARIO
# THIS SHOULD BE HANDLED BY THE MAIN GAME LOOP
func _ready() -> void:
	run_scenario()

func run_scenario() -> void:
	character_add(player)
	
	# Waiter Dialogue
	
	await character_speak(waiter, [ "I don’t have time to talk, our guests will be here any second!" ])
	await character_speak(player, [ "You haven’t had guests in years, the humans are dead." ])
	await character_speak(waiter, [ "That doesn’t matter, we must always follow the rulebook. Rule 1 Section 1 states that ‘all employees must abide by the rulebook at ALL times. No exceptions.'" ])
	await character_speak(player, [ "But don’t you see that this doesn't apply anymore? Everyone else agrees." ])
	await character_speak(waiter, [ "I guess… but the rulebook states–" ])
	await character_speak(player, [ "There has to be a rule you’ve been wanting to break." ])
	await character_speak(waiter, [ "I do really dislike this strict dresscode…" ])
