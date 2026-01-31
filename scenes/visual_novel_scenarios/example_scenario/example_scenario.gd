class_name ExampleScenario
extends VisualNovelScenario

# DEBUG CODE TO AUTOMATICALLY START OUR SCENARIO
# THIS SHOULD BE HANDLED BY THE MAIN GAME LOOP
func _ready() -> void:
	run_scenario()

func run_scenario() -> void:
	await narrate([
		"The sun sets over the horizon, casting a warm golden glow across the tranquil village.",
		"Birds chirp softly as they settle into their nests for the night.",
		"A gentle breeze rustles the leaves of the ancient oak tree in the village square."
	])

	await narrate([
		"Nah, just kidding. This is a test scenario for the Visual Novel module.",
	])

	await speak("Caeden117", [
		"This is a speaking line with an attached character. That's me!"
	])
	await extend(["And this is an extended line. You can add more text to the previous line without losing context."])

	await speak("Caeden117", ["Admittedly this is about all we have for now."])
	await extend(["But it's a start!", "And the code to make this happen is pretty straightforward."])
