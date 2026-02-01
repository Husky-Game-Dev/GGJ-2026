extends VisualNovelScenario

@export
var player: Character
@export
var waiter: Character
@export
var chef: Character

func run_scenario() -> void:
	character_clear_all()
	character_add(player, Vector2(-1500, -1000))
	character_add(chef, Vector2(0, -1000))
	character_add(waiter, Vector2(1000, -950))
	
	# Argument between Chef and Waiter Dialogue
	
	await character_speak(waiter, [ "We need these dishes out here right now!" ])
	await character_speak(chef, [ "I’ve been in the kitchen all week, can’t I just rest my grills for a second?" ])
	await character_speak(waiter, [ "No! Lunch is in 30. We need to feed these guests!" ])
	await character_speak(chef, ["Come on, it's not a crime to catch your breath."])
	await character_speak(waiter, ["ACTUALLY, rule 5 section 1 states that ‘no kitchen equipment is allowed a break during working hours.'"])
	await character_speak(chef, ["But rule 5 section 4 says that ‘a work week consists of 20 hours per day, 7 days a week!’"])
	await character_speak(chef, ["Hey newcomer, can't you see how crazy this is?!"])
	await character_speak(player, ["20 hours per day is a bit unreasonable…"])
	await character_speak(chef, ["SEE?!?"])
	await character_speak(waiter, ["Fine, whatever, let's see what everyone else has to say about it!"])
	
	character_remove(waiter)
	await narrate([ "The Waiter stomps off, clearly angry with the argument...", "After things cool down, The Chef turns towards you." ])
	# Chef Dialogue
	
	await character_speak(chef, ["Everyone around here is so stuck up these days."])
	await character_speak(chef, ["It’s not like this food goes anywhere, we've stopped getting visitors AGES ago... Ever since the humans went extinct..."])
	await character_speak(player, ["Then why are you even here? Can’t you just leave this place?"])
	await character_speak(chef, ["I wish… It's all I have ever known. I can’t just abandon everyone else. 'The show must go on', as they say."])
	await character_speak(chef, ["Hmm... If you find a way to convince everyone that this place is laughable then I will be forever in your debt. What do you say?"])
	await character_speak(player, ["I’ll give it a shot!"])
	await character_speak(chef, ["Everyone else is in the other room. Just for practice though, why don't you try to convice me that rule 5 is absurd?"])
