class_name Main extends Node

@export
var visual_novel_scenes: Array[VisualNovelScenario]

@export
var puzzle: Puzzle = null

@export
var transition_fade: TransitionFade = null

var _has_started: bool = false

func _ready() -> void:
	InputManager.input_state_changed.connect(_on_input_state_changed)

# Starts the game when needed
func _on_input_state_changed(old_state: InputManager.InputState, new_state: InputManager.InputState) -> void:
	if new_state == InputManager.InputState.GAMEPLAY and !_has_started:
		_has_started = true
		_game_transition_start()

# Handles pause menu
func _input(event: InputEvent) -> void:
	if InputManager.get_input_state() == InputManager.InputState.GAMEPLAY:
		if event.is_action(&"pause") && event.is_pressed():
			get_viewport().set_input_as_handled()
			InputManager.soft_push_input_state(InputManager.InputState.PAUSE_MENU)

# Handles game loop
func _game_transition_start() -> void:
	# Ensure everythings hidden, just to be safe
	for scene_to_hide: VisualNovelScenario in visual_novel_scenes:
		scene_to_hide.visible = false
		scene_to_hide.process_mode = Node.PROCESS_MODE_DISABLED
	puzzle.visible = false
	
	var scene: int = 0
	
	# Fade in to start
	await transition_fade.fade_in_transition()
	
	# This does give preference to the Visual Novel but I think thats ok?
	while scene < visual_novel_scenes.size():
		var vn_scene: VisualNovelScenario = visual_novel_scenes[scene]
		vn_scene.visible = true
		# Dont await this - will happen concurrently with our VN scenario
		transition_fade.fade_out_transition()
		
		# Waits for the visual scenario to run
		# Ignoring the warning because all implementing methods of VisualNovelScenario use await
		@warning_ignore("redundant_await")
		await vn_scene.run_scenario()
		await transition_fade.fade_in_transition()
		vn_scene.visible = false
		
		# Attempt to play a puzzle associated with this VN scene
		puzzle.load_level(scene)
		if (puzzle.loaded_level != -1):
			puzzle.visible = true
			await transition_fade.fade_out_transition()
			await puzzle.puzzle_complete
			await transition_fade.fade_in_transition()
			puzzle.visible = false
		
		scene += 1
	
	# By this point, assume the game is over, head to main menu
	InputManager.switch_input_state(InputManager.InputState.MAIN_MENU)
	transition_fade.fade_out_transition()
	_has_started = false
