extends VisualNovelScenario

@export
var player: Character
@export
var stocker: Character
@export
var chef: Character
@export
var conclusion_texture: CompressedTexture2D
@export
var scene_texture: CompressedTexture2D
@export
var background: TextureRect

func run_scenario() -> void:
	character_clear_all()
	character_add(player, Vector2(-1500, -1000))
	
	#Chef Conclusion
	character_add(chef, Vector2(0, -1000))
	set_background(background, conclusion_texture)
	
	await character_speak(chef, [ "Great job Delivery Guy! Convincing the Stocker would be a good start. He always trusted the last Delivery Bot." ])
	
	character_remove(chef)
	
	# Stocker Dialogue
	character_add(stocker, Vector2(500, -650))
	set_background(background, scene_texture)
	
	await character_speak(stocker, [ "Aah, that's where you are! I’ve been looking for you all… however long its been." ])
	await character_speak(player, [ "Sorry, I couldn’t find the loading bay." ])
	await character_speak(stocker, [ "Hey wait, you're not the usual delivery bot that comes around here." ])
	await character_speak(player, [ "Nope, this is my first day." ])
	await character_speak(stocker, [ "Between you and me, the last delivery bot used to slide me some oil… It's great for my gears!" ])
	await character_speak(stocker, [ "Soooo… Any chance you got some?" ])
	await character_speak(player, [ "Isn’t oil good for bots? Why would you need to get it in secret?" ])
	await character_speak(stocker, [ "Ugh, rule 3 section 2… ‘the consumption of oil is prohibited by all employees.’" ])
	await character_speak(player, [ "This should definitely be changed." ])
