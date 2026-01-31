extends Node


enum InputState { MAIN_MENU, PAUSE_MENU, SETTINGS_MENU, CUTSCENE, GAMEPLAY }


signal input_state_changed(old_state: InputState, new_state: InputState)
signal gamepad_active_changed(gamepad_active: bool)
signal gamepad_name_changed(gamepad_name: String, gamepaw_raw_name: String)


const DEFAULT_INPUT_STATE: InputState = InputState.MAIN_MENU
const GAMEPAD_TIMEOUT: int = 5000


var input_state_stack: Array[InputState] = []
var _gamepad_active: bool = false
var _last_gamepad_time: int = 0
var _last_gamepad_device: int = -1
var _last_gamepad_name: String = ""
var _last_gamepad_raw_name: String = ""
var _soft_update_this_frame: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	input_state_stack.push_back(DEFAULT_INPUT_STATE)
	input_state_changed.connect(_on_input_state_changed)
	input_state_changed.emit(DEFAULT_INPUT_STATE, DEFAULT_INPUT_STATE)
	input_state_changed.emit(DEFAULT_INPUT_STATE, DEFAULT_INPUT_STATE)
	await get_tree().process_frame
	input_state_changed.emit(DEFAULT_INPUT_STATE, DEFAULT_INPUT_STATE)


func _process(_delta: float) -> void:
	_soft_update_this_frame = false


func _input(event: InputEvent) -> void:
	if event is InputEventMouse || event is InputEventKey:
		if _gamepad_active && Time.get_ticks_msec() - _last_gamepad_time > GAMEPAD_TIMEOUT:
			_gamepad_active = false
			gamepad_active_changed.emit(_gamepad_active)
	if event is InputEventJoypadButton || event is InputEventJoypadMotion:
		_last_gamepad_time = Time.get_ticks_msec()
		if _last_gamepad_device != event.device || !_gamepad_active:
			var joy_info: Dictionary = Input.get_joy_info(event.device)
			var gamepad_name: String = Input.get_joy_name(event.device)
			var gamepad_raw_name: String = joy_info.get("raw_name", gamepad_name)
			if _last_gamepad_name != gamepad_name || _last_gamepad_raw_name != gamepad_raw_name:
				print(event)
				_last_gamepad_name = gamepad_name
				_last_gamepad_raw_name = gamepad_raw_name
				gamepad_name_changed.emit(gamepad_name, gamepad_raw_name)
		_last_gamepad_device = event.device
		if !_gamepad_active:
			_gamepad_active = true
			gamepad_active_changed.emit(_gamepad_active)


func _on_input_state_changed(_old_state: InputState, new_state: InputState) -> void:
	match new_state:
		InputState.MAIN_MENU, InputState.PAUSE_MENU, InputState.SETTINGS_MENU:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_tree().paused = true
		_:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_tree().paused = false


func get_input_state() -> InputState:
	if input_state_stack.is_empty():
		return DEFAULT_INPUT_STATE
	return input_state_stack[input_state_stack.size() - 1]


func push_input_state(state: InputState) -> void:
	var old_state: InputState = get_input_state()
	input_state_stack.push_back(state)
	input_state_changed.emit(old_state, get_input_state())


func pop_input_state() -> void:
	var old_state: InputState = get_input_state()
	input_state_stack.pop_back()
	if input_state_stack.is_empty():
		input_state_stack.push_back(DEFAULT_INPUT_STATE)
	input_state_changed.emit(old_state, get_input_state())


func switch_input_state(state: InputState) -> void:
	var old_state: InputState = get_input_state()
	input_state_stack.pop_back()
	input_state_stack.push_back(state)
	input_state_changed.emit(old_state, get_input_state())


func reset_input_state_stack(state: InputState = DEFAULT_INPUT_STATE) -> void:
	var old_state: InputState = get_input_state()
	input_state_stack.clear()
	input_state_stack.push_back(state)
	input_state_changed.emit(old_state, get_input_state())


func soft_push_input_state(state: InputState) -> void:
	if _soft_update_this_frame:
		return
	_soft_update_this_frame = true
	push_input_state(state)


func soft_pop_input_state() -> void:
	if _soft_update_this_frame:
		return
	_soft_update_this_frame = true
	pop_input_state()


func soft_switch_input_state(state: InputState) -> void:
	if _soft_update_this_frame:
		return
	_soft_update_this_frame = true
	switch_input_state(state)


func soft_reset_input_state_stack(state: InputState = DEFAULT_INPUT_STATE) -> void:
	if _soft_update_this_frame:
		return
	_soft_update_this_frame = true
	soft_reset_input_state_stack(state)


func is_gamepad_active() -> bool:
	return _gamepad_active


func reset_gamepad_status() -> void:
	_gamepad_active = false
	gamepad_active_changed.emit(_gamepad_active)


func is_in_ui() -> bool:
	var input_state: InputState = get_input_state()
	return input_state == InputState.MAIN_MENU || input_state == InputState.PAUSE_MENU || input_state == InputState.SETTINGS_MENU
